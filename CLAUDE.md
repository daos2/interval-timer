# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Layout

Flutter app. **Android only in practice** — `3-code/ios/` contains generated leftovers (an AppIcon set, `GeneratedPluginRegistrant`) but no `Runner.xcodeproj`, `Info.plist` or `Podfile`, so iOS cannot build until it is regenerated with `flutter create --platforms=ios .`. **The project is not at the repo root — it lives in `3-code/`.** Run every `flutter`/`dart` command from there.

```
Interval_timer/
├── 3-code/       the Flutter project (source + build/ output)
├── 5-releases/   shipped APKs, named "Interval timer vX.Y.Z.apk"
└── logo*.jpg     icon design sources
```

The repository is git-tracked as of v1.4.0. Shipped APKs under `5-releases/` are **deliberately untracked** (`.gitignore`): at ~47 MB each they would live in the history forever, and git cannot drop them again without a rewrite. Publish them as GitHub Release assets instead.

The root `README.md` is the GitHub landing page; `3-code/README.md` remains the developer-facing one. Both carry the version number, so a bump touches them too.

`3-code/` is the only source tree. A second full copy at `4-build/` and an older one at the repo root were deleted in v1.2: they had silently drifted, and the stale copy still carried the old `com.example.interval_timer` application ID, so an APK built from it installed as a *second* app instead of upgrading. Do not reintroduce a parallel project copy.

## Commands

All from `3-code/`:

```bash
flutter pub get
flutter analyze                    # must stay at "No issues found!"
flutter test                       # 71 tests
flutter test test/backup_test.dart
flutter test --plain-name "prestart 0 starts the workout immediately"
flutter build apk --release        # ~6 min warm, ~16 min cold
```

To release: build, then copy `build/app/outputs/flutter-apk/app-release.apk` to `5-releases/Interval timer v<version>.apk`.

A version bump touches **two** places that must agree: `version:` in `pubspec.yaml` and `BackupService.appVersion`, which is stamped into every backup manifest.

Releases are signed with the Flutter **debug** key (see `android/app/build.gradle.kts`). Every shipped APK shares that key, so they upgrade in place. Switching to a real key breaks in-place upgrade and forces an uninstall/reinstall, which loses settings and history unless the user exports a backup first.

## Architecture

`TimerController` (`lib/features/timer/timer_controller.dart`) is the single source of truth: session state, settings and history all live there. Every screen is stateless and reads it via `context.watch`. It is provided once in `main.dart`, after both repositories have loaded from disk.

**Phases:** `idle → prestart → workout ⇄ rest → completed`, with `paused` reachable from the running phases. `_pausedFromWorkout`/`_pausedFromPrestart` record where a pause came from so `_resume()` can return to it.

**Timing:** a 100 ms `Timer.periodic` advances state from wall-clock deltas (`DateTime.now()` differences) rather than counting ticks, so the session does not drift. Two independent clocks:

- `phaseElapsedMs` / `remainingPhaseMs` — the current phase, reset at each transition.
- `elapsedMs` — total trained time. Excludes the prestart countdown and freezes while paused. **This is what history records.** Do not substitute wall-clock time; an earlier version did and overstated every entry in Statistics.

**Audio:** `SoundService` synthesises WAV tones in memory at runtime — there are no audio assets. Players are created lazily on first use, and every playback path swallows its own exceptions: a missed cue must never interrupt a running workout.

**Persistence:** two JSON strings in SharedPreferences, `app_settings_json` and `workout_history_json`. Both models tolerate missing keys and clamp out-of-range values, so older saved data loads without migration code. Note that renaming a persisted key silently resets that field for existing users — this happened once, with `frequenceSeconds` → `frequencySeconds`.

**Statistics charts:** `training_totals.dart` holds the calendar bucketing and is deliberately Flutter-free, so the rules that are easy to get wrong (which day a session lands in, how far the axis runs) are unit tested without a widget tree. Buckets run **newest-first** and include periods with no training, which is what lets the scrolling strip in `training_chart.dart` open pinned to today and still show gaps honestly. Bar height counts *every* recorded session, while `TimerController.totalTrainedSeconds` and the weekly headers count completed ones only — those totals differ on purpose, not by accident.

**Donations:** `features/info/donation.dart` holds the address, chain and QR asset for each network and, like `training_totals.dart`, imports no Flutter. A wrong address there is unrecoverable for the user, so the strings are pinned by `test/donation_test.dart` rather than trusted to review. The QR images in `assets/donate/` were decoded with OpenCV and checked against those strings before being committed; they are cropped to the code plus its quiet zone, with the original screenshot's black frame and caption removed, which is why the screen can put them on a plain white panel with no seam. Ethereum and BNB Chain deliberately share one address -- same key, two chains -- and the screen says so.

**Backup:** those same two JSON documents plus a `manifest.json` make up the `.zip`. `BackupService.read()` validates the whole archive and throws `BackupFormatException` *before* the controller mutates anything, so a failed import is a genuine no-op. Bump `BackupService.schemaVersion` only for a layout change older builds cannot read.

## Invariants

Each of these fixed a real bug; they are load-bearing.

- **`updateSettings` calls `notifyListeners()` before awaiting persistence and the wakelock.** Awaiting first meant a throwing dependency could skip the repaint entirely, freezing the Settings screen on stale values.
- **`_syncWakelock()` and all `SoundService` playback catch their own exceptions.** They are best-effort side effects, never a reason to abort a caller.
- **Stepper buttons in `timer_screen.dart` are `Flexible` with `FittedBox` labels.** Fixed-width buttons overflowed on 360 dp-wide phones, and an overflowed button is also untappable.
- **Frequency is stored as whole hundredths of a second.** Stepper `steps` are integers in hundredths (±1, ±10, ±100) and `setFrequency` re-snaps, so repeated ±0.01 taps cannot accumulate floating-point drift. Displayed with `toStringAsFixed(2)`.
- **A Row's non-flex child that sizes to its text needs a cap, not a `Flexible`.** The Statistics week-header chip sits between two `Expanded` rules. Left unbounded it pushed them to negative width; wrapping it in `Flexible` was worse, because three flex children split the row evenly and starved the chip to a third of the width whatever its label said. It is capped with a `LayoutBuilder` + `ConstrainedBox` instead, and its texts ellipsise.
- **A perpetual animation on a screen under test makes `pumpAndSettle` hang.** The Timer app bar's info badge pulses forever, so `_host` in `layout_test.dart` switches animations off through `MediaQuery.disableAnimations` (which `InfoButton` honours, as Android's "Remove animations" setting does). Tests that want the pulse pass `animations: true` and step with explicit `pump(duration)` calls.
- **`AnimatedSwitcher` lays its children out loosely.** It stacks them with `StackFit.loose`, so a child that would otherwise be stretched by tight constraints silently shrink-wraps instead. The donation QR panel took the bitmap's pixel size that way until it was wrapped in `SizedBox.expand`.
- **`prestartSeconds` is 0–20, clamped in both `copyWith` and `fromJson`.** 0 means `_startNewSession` skips the prestart phase entirely rather than running a zero-length one.

## Testing

`test/layout_test.dart` renders the timer, settings and statistics screens at 320 px and 360 px and asserts `tester.takeException()` is null, so any `RenderFlex` overflow fails the suite. Layout regressions are caught without a device — keep this in mind when changing any row of controls.

The test font makes every glyph a square of the font size, so text is far wider there than on a device. That is useful — it surfaces latent overflows early — but a failure at 320 px is not automatically a real-device bug, so check the geometry before reflowing a layout to satisfy it.

Widget tests involving dates build their fixtures relative to `DateTime.now()`, because the chart's axis runs up to the current period. That makes it easy to write an assertion that only holds on some weekdays: one chart test passed only on Mondays, because on every other day "today" and "yesterday" fall in the same week and the week header then shows the same total as the Overview card. Scope such finders to the widget under test instead of counting matches screen-wide.

A `ListView` only builds what is on screen, so a widget below the fold does not exist to be found. The info-screen tests use a tall viewport when asserting on content, and scroll only in the test that is actually measuring overflow.

Unit tests must not touch platform plugins. Construct `TimerController` with `timerSignalEnabled: false` to keep the audio plugin out of it, and call `SharedPreferences.setMockInitialValues({})` once per file.

Not covered by tests: the system file-picker dialogs used by backup export/import, and anything needing a real device.

## Docs

`3-code/plan.txt` is the feature summary, changelog and known-limitations list. `3-code/README.md` covers layout, commands and architecture. Both are current as of v1.4.0+5 — keep them so when behaviour changes.
