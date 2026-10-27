# Interval Timer

A Flutter interval timer for HIIT, Tabata and circuit training. Configurable
work/rest intervals, audio cues synthesised at runtime, training statistics
with day/week/month charts, and zip backup/restore.

Everything is stored on the device. No account, no ads, no analytics, and the
app asks for **no Android permissions**.

**Current version 1.5.0+6** · Application ID `com.intervaltimer.app` ·
Android 7.0+ (API 24)

> Translations outside English are machine-produced and have not been reviewed
> by native speakers. Corrections are welcome — the strings live in
> [`source/lib/l10n/`](source/lib/l10n/), one `.arb` file per language.

## Install

Download the APK from the [Releases](../../releases) page and sideload it.

Every release is signed with the same key, so a new version installs over the
old one and keeps your settings and history. It is the Flutter **debug** key:
fine for sideloading, not publishable to Google Play. If that ever changes you
will have to uninstall first — export a backup before you do.

## How to use it

**1 · Set up the session.** The Timer tab is four steppers, each with coarse
and fine buttons on either side of the value:

| Field | What it means | Buttons |
| --- | --- | --- |
| Workout interval | Length of one work period, in units | ±1, ±5, ±60 |
| Rest interval | Recovery between sets, in seconds | ±1, ±5, ±60 |
| Sets | How many work periods to run | ±1, ±5 |
| Frequency | Seconds between tick sounds | ±0.01, ±0.1, ±1.0 |

A summary underneath shows total duration, work time and rest time as you
change them. **RESET** restores the defaults.

**2 · Start.** Press **START**. A countdown (10 s by default) gives you time to
get into position, then the first work period begins.

**3 · Train without looking.** The screen is colour-coded by phase — blue
prestart, green work, orange rest, purple done — and every change has its own
sound, so the phone can stay in your pocket:

- A two-tone marker opens each work period, and sounds again when rest begins.
- A tick counts every unit.
- The last unit of a period ticks longer, as a warning.

**4 · Pause or stop.** **PAUSE** holds the session; tap anywhere on the paused
screen to resume. **RESET** ends it. Paused time is not counted as training.

**5 · Review.** Every finished session lands in the Statistics tab.

## Features

**Timer**
- Four configurable fields. Frequency is held to whole hundredths of a second,
  so repeated fine taps never accumulate drift.
- Prestart countdown of 0–20 s; 0 starts instantly.
- Large countdown with a progress ring, a set counter, and an optional overall
  progress bar.
- The screen stays awake while a session runs.

**Sound** — six tick sounds and three completion fanfares, previewable in
Settings. All are synthesised as WAV in memory, so the app ships no audio
files. A failed cue (lost audio focus, no output device) is swallowed rather
than interrupting the workout.

**Statistics**
- A bar chart of training time with **DAY / WEEK / MONTH** buttons. It scrolls
  sideways and opens on the newest period, so bars stay readable however long
  the history grows. Rest days remain on the axis as empty bars. Tap a bar for
  its exact total, date range and session count.
- Totals, weekly grouping by ISO week, and a session list showing date,
  settings, duration and whether it was completed.
- Recorded duration is *actual trained time*: it excludes the countdown and any
  time spent paused.

**Backup & restore** — export settings and history to a `.zip` and import them
back. The archive is plain JSON (`manifest.json`, `settings.json`,
`history.json`), so you can inspect or edit it with any zip tool. An import is
validated in full and confirmed before anything is replaced, so a damaged or
foreign file is a no-op. It uses the system file picker, which is why no
storage permission is needed.

**Languages** — English, Deutsch, Français, Español, Русский, ქართული. Pick one
in Settings → LANGUAGE or leave it on *System default*. Dates, month names and
plural forms follow your choice. Languages are listed in their own language, so
you can always find your way back.

**About & Support** — the pulsing **I** badge beside the title on the Timer
screen explains what the app is for and holds the donation addresses.

## Settings reference

| Setting | Default | Effect |
| --- | --- | --- |
| Keep screen on | On | Stops the display sleeping mid-session |
| Progress bar | On | Shows or hides overall completion |
| Timer signal | On | Ticks at every workout unit |
| Prestart | 10 s | Countdown before the first interval; 0 starts instantly |
| Tick sound | Soft click | One of six |
| Done fanfare | Classic | One of three |
| Language | System | One of six, or follow the phone |

## Known limitations

- Backgrounding the app throttles the timer. Elapsed time self-corrects on
  return, but ticks during the gap are skipped. Keeping the screen on — the
  default — avoids it.
- History cannot be cleared or edited in the app. It can be changed out of band
  by unzipping a backup, editing `history.json` and importing it again.
- The chart counts every recorded session, while the Overview card and weekly
  headers count completed ones only, so those totals differ when a session was
  abandoned.
- The chart's day/week/month choice is not remembered between visits.
- No in-app volume control; cue volume follows device media volume.
- The preview ▶ button in Settings also selects that sound.

## Build from source

The Flutter project lives in `source/`, not at the repository root.

```bash
cd source
flutter pub get
flutter run                     # debug, on a connected device
flutter build apk --release     # output in build/app/outputs/flutter-apk/
```

Checks, both of which should be clean:

```bash
cd source
flutter analyze
flutter test
```

Translations are generated from `lib/l10n/*.arb` during `flutter pub get`; run
`flutter gen-l10n` to regenerate them by hand.

## Repository layout

```
Interval_timer/
├── source/        the Flutter project (source, tests, docs)
├── fastlane/      store listing text, used by F-Droid
├── 5-releases/    shipped APKs (not tracked in git — see Releases)
├── donate/        QR source images
└── logo*.jpg      app icon design sources
```

APKs are kept out of git deliberately: at ~50 MB each they would be cloned by
everyone, forever, and git cannot drop them later without rewriting history.
They belong on the Releases page instead.

## Documentation

- [`source/README.md`](source/README.md) — architecture, commands, file map
- [`CLAUDE.md`](CLAUDE.md) — working notes and load-bearing invariants

## Support

If the app is useful to you, a tip is welcome. The same addresses are in the
app under the **I** badge, with scannable QR codes.

| Network | Address |
| --- | --- |
| Bitcoin | `bc1q8svagqq04223y5emu2n250qkgzqu6vm806lhh3` |
| Ethereum (ERC20) | `0x2Fc833C2166E8951534f6FEf2ea1A89790e16517` |
| BNB Chain (BEP20) | `0x2Fc833C2166E8951534f6FEf2ea1A89790e16517` |

Ethereum and BNB Chain share one address — it is one key on two chains — so the
network you send on is what decides where the funds land.

## License

[MIT](LICENSE) © 2026 daos2 — free to use, modify and redistribute, including
commercially, as long as the copyright notice is kept. The software comes with
no warranty.
