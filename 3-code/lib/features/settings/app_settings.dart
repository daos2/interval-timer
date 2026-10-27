class AppSettings {
  /// Prestart countdown bounds, in seconds. 0 skips the countdown entirely.
  static const int minPrestartSeconds = 0;
  static const int maxPrestartSeconds = 20;
  static const int defaultPrestartSeconds = 10;

  const AppSettings({
    this.keepScreenOn = true,
    this.showProgressBar = true,
    this.timerSignalEnabled = true,
    this.tickSoundId = 'tick1',
    this.doneSoundId = 'done1',
    this.prestartSeconds = defaultPrestartSeconds,
  });

  final bool keepScreenOn;
  final bool showProgressBar;
  final bool timerSignalEnabled;
  final String tickSoundId;
  final String doneSoundId;
  final int prestartSeconds;

  AppSettings copyWith({
    bool? keepScreenOn,
    bool? showProgressBar,
    bool? timerSignalEnabled,
    String? tickSoundId,
    String? doneSoundId,
    int? prestartSeconds,
  }) {
    return AppSettings(
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      showProgressBar: showProgressBar ?? this.showProgressBar,
      timerSignalEnabled: timerSignalEnabled ?? this.timerSignalEnabled,
      tickSoundId: tickSoundId ?? this.tickSoundId,
      doneSoundId: doneSoundId ?? this.doneSoundId,
      prestartSeconds: _clampPrestart(prestartSeconds ?? this.prestartSeconds),
    );
  }

  Map<String, Object> toJson() {
    return <String, Object>{
      'keepScreenOn': keepScreenOn,
      'showProgressBar': showProgressBar,
      'timerSignalEnabled': timerSignalEnabled,
      'tickSoundId': tickSoundId,
      'doneSoundId': doneSoundId,
      'prestartSeconds': prestartSeconds,
    };
  }

  factory AppSettings.fromJson(Map<String, Object?> json) {
    return AppSettings(
      keepScreenOn: json['keepScreenOn'] as bool? ?? true,
      showProgressBar: json['showProgressBar'] as bool? ?? true,
      timerSignalEnabled: json['timerSignalEnabled'] as bool? ?? true,
      tickSoundId: json['tickSoundId'] as String? ?? 'tick1',
      doneSoundId: json['doneSoundId'] as String? ?? 'done1',
      prestartSeconds: _clampPrestart(
          (json['prestartSeconds'] as num?)?.toInt() ?? defaultPrestartSeconds),
    );
  }

  static int _clampPrestart(int value) =>
      value.clamp(minPrestartSeconds, maxPrestartSeconds);
}
