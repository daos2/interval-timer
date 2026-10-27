# Interval Timer

A Flutter interval-timer app for HIIT, Tabata and circuit training: configurable
work/rest intervals, synthesised audio cues, training-time charts, zip
backup/restore, and an about/donations screen.

Version **1.5.0+6** · Application ID `com.intervaltimer.app` · Android 7.0+ (API 24)

Android only in practice: `ios/` holds generated leftovers but no Xcode project,
so iOS has to be regenerated with `flutter create --platforms=ios .` before it
can build.

See [`plan.txt`](plan.txt) for the full feature summary, changelog and known
limitations.

## Repository layout

```
Interval_timer/
├── 3-code/        the Flutter project (source + build output)
├── 5-releases/    shipped APKs
├── logo.jpg       icon design source
└── logo2.jpg
```

There used to be a second full copy of the project in `4-build/`, plus an older
one at the root. They drifted: the "source" folder fell behind and still carried
the old `com.example.interval_timer` application ID, so an APK built from it
installed as a *second* app instead of upgrading the existing one. Both copies
were removed in v1.2 — `3-code/` is now the only project.

## Getting started

```bash
flutter pub get
flutter run
```

## Checks

```bash
flutter analyze && flutter test
```

Both should be clean: no analyzer issues, 80 tests passing. The widget tests
render the setup, settings and statistics screens at 320 px and 360 px wide and
fail on any `RenderFlex` overflow, so layout regressions are caught without a
device. The backup tests cover the archive round trip plus every rejection path
(not a zip, missing manifest, newer schema, truncated archive, damaged rows).
The chart tests cover calendar bucketing — Monday-aligned weeks, gap filling,
year boundaries, future-dated and corrupt rows — as plain unit tests.

## Building a release APK

```bash
flutter build apk --release
```

Output lands in `build/app/outputs/flutter-apk/app-release.apk`; copy it to
`5-releases/`. Releases are signed with the Flutter **debug** key (see
`android/app/build.gradle.kts`) — fine for sideloading, not for Play.

## Architecture

```
lib/
  main.dart                    app entry, Provider wiring
  theme.dart                   shared dark-theme colour tokens
  screens/home_screen.dart     bottom navigation shell
  features/
    timer/
      timer_controller.dart    ChangeNotifier — all session state and timing
      timer_screen.dart        setup screen + active workout view
      sound_service.dart       runtime WAV synthesis, no audio assets
    backup/
      backup_service.dart      zip export/import of settings + history
    info/
      donation.dart            donation addresses + QR pairing (pure Dart)
      info_screen.dart         "I" app-bar badge and About & Support screen
  l10n/
    app_*.arb                  translations, one file per language
    app_localizations*.dart    generated from the .arb files
    l10n_ext.dart              id -> translated text (sounds, periods, durations)
    settings/
      app_settings.dart        immutable settings model + JSON
      settings_repository.dart SharedPreferences persistence
      settings_screen.dart     settings UI
    statistics/
      workout_record.dart      immutable history entry + JSON
      workout_history_repository.dart
      training_totals.dart     calendar bucketing + duration wording (pure Dart)
      training_chart.dart      day/week/month bar chart card
      statistics_screen.dart   chart, weekly grouping and history list
```

`TimerController` is the single source of truth. It owns the 100 ms ticker,
which advances state from wall-clock deltas rather than counting ticks, so the
session does not drift. Screens are stateless and read it via `context.watch`.

Settings and history are persisted as JSON strings in SharedPreferences under
`app_settings_json` and `workout_history_json`. Both models tolerate missing
keys, so older saved data loads without migration.

The Statistics chart buckets history by day, week or month in
`training_totals.dart`, which is deliberately free of Flutter imports so the
calendar rules are unit tested without a widget tree. Buckets run newest-first
and include periods with no training, so the horizontally scrolling strip in
`training_chart.dart` can open pinned to today and still show gaps honestly.
Bar height counts every recorded session; the Overview card and weekly headers
count completed sessions only, so those totals differ when abandoned sessions
exist.

The UI is translated through Flutter's `gen_l10n`: `lib/l10n/*.arb` hold the
strings and the Dart in the same folder is generated from them by
`flutter gen-l10n` (and automatically by `flutter pub get`, since
`generate: true` is set). The chosen language lives in `AppSettings
.languageCode`, where `''` means "follow the system"; `main.dart` turns it
into `MaterialApp.locale` and sets `Intl.defaultLocale` so bare `DateFormat`
calls follow suit. Nothing user-visible belongs in a controller or model:
sound names and phase labels are ids, resolved to text by `l10n_ext.dart`
at paint time.

The About & Support screen keeps its donation addresses in `donation.dart`,
again Flutter-free, so the pairing of address to network to QR image is unit
tested on its own -- a wrong address there sends a user's money somewhere
unrecoverable. The QR assets in `assets/donate/` are cropped to the code
itself, with a white quiet zone and no frame, so the screen can draw them on a
plain white panel with no visible seam.

The same two JSON documents, plus a `manifest.json` carrying the schema version
and export time, make up the backup archive. `BackupService.read` validates the
whole archive before the controller replaces any state, so a failed import is a
no-op. Bump `BackupService.schemaVersion` only if the layout changes in a way
older builds cannot read.
