// Bridges the generated AppLocalizations to the places that hold ids rather
// than text: sound options, chart periods and composed durations.
import 'package:flutter/widgets.dart';

import '../features/statistics/training_totals.dart';
import 'app_localizations.dart';

/// Shorthand so widgets can write `context.l10n.navTimer`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension L10nLookups on AppLocalizations {
  /// Display name for a tick or fanfare id. Unknown ids fall back to the id
  /// itself: a sound added to settings but not yet translated should show up
  /// as something selectable, not as a blank row.
  String soundName(String id) => switch (id) {
        'tick1' => tick1,
        'tick2' => tick2,
        'tick3' => tick3,
        'tick4' => tick4,
        'tick5' => tick5,
        'tick6' => tick6,
        'done1' => done1,
        'done2' => done2,
        'done3' => done3,
        _ => id,
      };

  String periodButton(ChartPeriod period) => switch (period) {
        ChartPeriod.day => periodDay,
        ChartPeriod.week => periodWeek,
        ChartPeriod.month => periodMonth,
      };

  /// "3 days" / "1 month" -- pluralised by the ARB, which matters well
  /// beyond English: Russian picks between three forms here.
  String periodCount(ChartPeriod period, int count) => switch (period) {
        ChartPeriod.day => daysCount(count),
        ChartPeriod.week => weeksCount(count),
        ChartPeriod.month => monthsCount(count),
      };

  DurationWords get durationWords => _L10nDurationWords(this);

  /// "1 h 20 min 5 sec" in the current language.
  String duration(int seconds) => humanDuration(seconds, durationWords);

  /// Axis-tick sized: "2 h", "45 m".
  String durationCompact(int seconds) =>
      compactDuration(seconds, durationWords);
}

class _L10nDurationWords implements DurationWords {
  const _L10nDurationWords(this._l);
  final AppLocalizations _l;

  @override
  String hour(int n) => _l.durHour(n);
  @override
  String minute(int n) => _l.durMin(n);
  @override
  String second(int n) => _l.durSec(n);
  @override
  String get none => _l.durNone;
  @override
  String compactHour(String n) => _l.durCompactHour(n);
  @override
  String compactMinute(int n) => _l.durCompactMin(n);
  @override
  String compactSecond(int n) => _l.durCompactSec(n);
}
