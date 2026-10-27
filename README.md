# Interval Timer

A Flutter interval timer for HIIT, Tabata and circuit training. Configurable
work/rest intervals, audio cues synthesised at runtime, training statistics
with day/week/month charts, and zip backup/restore.

Everything is stored on the device. No account, no ads, no analytics, and the
app asks for no Android permissions.

**Current version 1.4.0+5** · Application ID `com.intervaltimer.app` ·
Android 7.0+ (API 24)

## Features

- **Workout setup** — work interval, rest, sets, and tick frequency, each with
  coarse and fine stepper buttons. Frequency is held to whole hundredths of a
  second, so repeated taps never drift.
- **Prestart countdown** — 0–20 seconds to get into position; 0 starts instantly.
- **Audio cues** — six tick sounds and three completion fanfares, generated as
  WAV in memory, so the app ships no audio files. A missed cue never interrupts
  a running session.
- **Screen stays awake** while a session runs.
- **Statistics** — totals, weekly grouping, session history, and a horizontally
  scrolling bar chart of training time by day, week or month.
- **Backup & restore** — export settings and history to a `.zip` and import
  them back. Imports are validated in full before anything is replaced, so a
  bad file is a no-op.
- **About & Support** — what the app is for, plus a tip jar.

## Install

Grab the APK from the [Releases](../../releases) page and sideload it.

Every release so far is signed with the Flutter **debug** key. That is fine for
sideloading and means each build upgrades the previous one in place, keeping
your settings and history — but it is not publishable to Google Play, and
moving to a real signing key later will require an uninstall first. Export a
backup before that happens.

## Build from source

The Flutter project lives in `3-code/`, not at the repository root.

```bash
cd 3-code
flutter pub get
flutter run                     # debug, on a connected device
flutter build apk --release     # output in build/app/outputs/flutter-apk/
```

Checks, both of which should be clean:

```bash
cd 3-code
flutter analyze
flutter test
```

## Repository layout

```
Interval_timer/
├── 3-code/        the Flutter project (source, tests, docs)
├── 5-releases/    shipped APKs (not tracked in git — see Releases)
├── donate/        QR source images
└── logo*.jpg      app icon design sources
```

APKs are kept out of git deliberately: at ~47 MB each they would be cloned by
everyone, forever, and git cannot drop them later without rewriting history.
They belong on the Releases page instead.

## Documentation

- [`3-code/README.md`](3-code/README.md) — architecture, commands, file map
- [`3-code/plan.txt`](3-code/plan.txt) — feature summary, changelog, known limitations
- [`CLAUDE.md`](CLAUDE.md) — working notes and load-bearing invariants

## Support

If the app is useful to you, a tip is welcome. The same addresses are in the
app under the "I" badge, with scannable QR codes.

| Network | Address |
| --- | --- |
| Bitcoin | `bc1q8svagqq04223y5emu2n250qkgzqu6vm806lhh3` |
| Ethereum (ERC20) | `0x2Fc833C2166E8951534f6FEf2ea1A89790e16517` |
| BNB Chain (BEP20) | `0x2Fc833C2166E8951534f6FEf2ea1A89790e16517` |

Ethereum and BNB Chain share one address — it is one key on two chains — so the
network you send on is what decides where the funds land.

## License

Not yet licensed. Without a license file, default copyright applies and others
have no rights to reuse the code.
