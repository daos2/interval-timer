# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Layout

Flutter app. **Android only in practice** — `source/ios/` contains generated leftovers (an AppIcon set, `GeneratedPluginRegistrant`) but no `Runner.xcodeproj`, `Info.plist` or `Podfile`, so iOS cannot build until it is regenerated with `flutter create --platforms=ios .`. **The project is not at the repo root — it lives in `source/`.** Run every `flutter`/`dart` command from there.

```
Interval_timer/
├── source/       the Flutter project (source + build/ output)
├── fastlane/     store-listing text (F-Droid reads metadata/android/<locale>/)
├── 5-releases/   shipped APKs, named "Interval timer vX.Y.Z.apk"
└── logo*.jpg     icon design sources
```

The repository is git-tracked as of v1.4.0. Shipped APKs under `5-releases/` are **deliberately untracked** (`.gitignore`): at ~47 MB each they would live in the history forever, and git cannot drop them again without a rewrite. Publish them as GitHub Release assets instead.

The root `README.md` is the GitHub landing page; `source/README.md` remains the developer-facing one. Both carry the version number, so a bump touches them too.

The project folder was named `3-code/` until v1.5.0; it is `source/` now. Nothing outside the docs referenced the old name, but `.dart_tool/` and `build/` cache absolute paths, so after any such move they must be deleted and `flutter pub get` re-run.

A `flutter build apk` leaves a **Gradle daemon** holding a lock on the project folder, which makes a rename fail with "Permission denied". Stop it with `./gradlew --stop` from `source/android` rather than killing java processes — Android Studio uses the same JBR runtime.

**Store listing:** `fastlane/metadata/android/en-US/` holds `title.txt` (max 50), `short_description.txt` (max 80, single line, **no trailing period**), `full_description.txt` (max 4000, limited HTML) and `changelogs/<versionCode>.txt` (max 500). F-Droid reads these straight from the repo, so a release that bumps versionCode wants a new changelog file beside the others. `images/icon.png` is a **512x512 square** crop of the portrait `source/icon/app_icon.jpg`, centred on the figure and stopwatch so the source card's white rounded corners stay outside the frame; regenerate it rather than scaling the portrait, which would distort it. Still missing for a submission: `images/phoneScreenshots/`, which needs a device.

**App icon:** `source/icon/` holds the build-time sources and is deliberately
*not* a bundled asset directory -- nothing in `lib/` loads them, so declaring
them under `flutter: assets:` only grew the APK. `app_icon.jpg` is the original
784x1168 portrait art; the other two are square crops generated from it.
Regenerate the Android resources with `dart run flutter_launcher_icons` from
`source/`.

- `app_icon_square.jpg` -> `mipmap-*/ic_launcher.png`, the legacy icon. It must
  be square: fed the portrait original, the generator preserved the 2:3 aspect,
  so every density shipped squashed -- the 192x192 slot held a 129x192 image.
- `app_icon_foreground.jpg` -> `drawable-*/ic_launcher_foreground.png`, paired
  with `@color/ic_launcher_background` (`#12101B`, the card colour) by
  `mipmap-anydpi-v26/ic_launcher.xml`. Without an adaptive icon, Android 8+
  shrinks the legacy one onto a white badge. Android only promises the central
  66dp circle of the 108dp canvas survives the launcher's mask, so the art is
  padded until the figure and stopwatch fill 60% of the frame; the sideways
  padding is the card colour, cross-faded over 40px because flat colour butted
  against faint lightning leaves a seam.
- **`ios: false` in the `flutter_launcher_icons:` block is load-bearing.** There
  is no `ios/Runner.xcodeproj`, so the iOS pass throws `PathNotFoundException`,
  and the uncaught error kills the process before the Android writes it has
  already queued are flushed -- the run prints "Successfully generated launcher
  icons" while leaving the mipmaps untouched and `colors.xml` empty.
- `mipmap-ldpi/` was deleted: the generator does not write it, so the stale
  squashed icon would have outlived the fix. Android falls back to mdpi.

`source/` is the only source tree. A second full copy at `4-build/` and an older one at the repo root were deleted in v1.2: they had silently drifted, and the stale copy still carried the old `com.example.interval_timer` application ID, so an APK built from it installed as a *second* app instead of upgrading. Do not reintroduce a parallel project copy.

## Commands

All from `source/`:

```bash
flutter pub get
flutter analyze                    # must stay at "No issues found!"
flutter test                       # 80 tests
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

**Localization:** `lib/l10n/*.arb` are the source of truth; the Dart beside them is generated by `flutter gen-l10n`, which `flutter pub get` also runs because `generate: true` is set in `pubspec.yaml`. Add a string to **every** `app_*.arb` at once — a key missing from one locale does not fail the build, it silently falls back to English, which is why `test/l10n_test.dart` asserts key parity across all six files. The selected language is `AppSettings.languageCode` (`''` = follow the system, clamped to `supportedLanguageCodes` in `copyWith`/`fromJson`), and `main.dart` sets `Intl.defaultLocale` in `localeResolutionCallback` so bare `DateFormat` calls follow the UI language. Controllers and models hold **ids, never display text**: `l10n_ext.dart` maps sound ids, chart periods and duration units to translated strings at paint time.

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
- **Duration wording is injected, not hardcoded.** `humanDuration`/`compactDuration` in `training_totals.dart` take a `DurationWords`; the file stays Flutter-free and language-free, and the tests assert the composition rules (which units appear, in what order) rather than one language's words.
- **`prestartSeconds` is 0–20, clamped in both `copyWith` and `fromJson`.** 0 means `_startNewSession` skips the prestart phase entirely rather than running a zero-length one.

## Testing

`test/layout_test.dart` renders the timer, settings and statistics screens at 320 px and 360 px and asserts `tester.takeException()` is null, so any `RenderFlex` overflow fails the suite. Layout regressions are caught without a device — keep this in mind when changing any row of controls.

The test font makes every glyph a square of the font size, so text is far wider there than on a device. That is useful — it surfaces latent overflows early — but a failure at 320 px is not automatically a real-device bug, so check the geometry before reflowing a layout to satisfy it.

Widget tests involving dates build their fixtures relative to `DateTime.now()`, because the chart's axis runs up to the current period. That makes it easy to write an assertion that only holds on some weekdays: one chart test passed only on Mondays, because on every other day "today" and "yesterday" fall in the same week and the week header then shows the same total as the Overview card. Scope such finders to the widget under test instead of counting matches screen-wide.

A `ListView` only builds what is on screen, so a widget below the fold does not exist to be found. The info-screen tests use a tall viewport when asserting on content, and scroll only in the test that is actually measuring overflow.

Do not `await controller.updateSettings(...)` before `pumpWidget` in a widget test: it waits on platform-channel work that only completes once the binding pumps frames, so the test hangs until it times out. Seed the state through the `TimerController` constructor instead.

Unit tests must not touch platform plugins. Construct `TimerController` with `timerSignalEnabled: false` to keep the audio plugin out of it, and call `SharedPreferences.setMockInitialValues({})` once per file.

Not covered by tests: the system file-picker dialogs used by backup export/import, and anything needing a real device.

## Docs

Licensed MIT (`LICENSE` at the repo root); the root `README.md` states it too.

The root `README.md` is the published account of the app: what it does, how to use it, the settings reference and the known limitations. It is the GitHub landing page, and it carries the version number. `source/README.md` is the developer-facing one — layout, commands, architecture. Both are current as of v1.5.0+6; keep them so when behaviour changes.

`source/plan.txt` still exists locally as scratch working notes but is **untracked on purpose** (see `.gitignore`). Do not restore it to git and do not treat it as authoritative: it duplicated the README's feature list and the two drifted. Anything worth publishing belongs in a README.
