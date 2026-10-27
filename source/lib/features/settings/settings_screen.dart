import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/l10n_ext.dart';
import '../../theme.dart';
import '../backup/backup_service.dart';
import '../timer/timer_controller.dart';
import 'app_settings.dart';

// ── Local aliases for shared tokens ───────────────────────────────────────
const _kBg = kBg;
const _kSurface = kSurface;
const _kSurfaceHigh = kSurfaceHigh;
const _kAccent = kAccent;
const _kTextPrimary = kTextPrimary;
const _kTextSub = kTextSub;
const _kDivider = kSurfaceHigh;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TimerController>();
    final settings = controller.settings;
    final l = context.l10n;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _kBg,
        appBar: AppBar(
          backgroundColor: _kBg,
          elevation: 0,
          centerTitle: true,
          title: Text(
            l.settingsTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _kTextPrimary,
              letterSpacing: 0.5,
            ),
          ),
          iconTheme: const IconThemeData(color: _kTextPrimary),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            // ── General section ────────────────────────────────────────────
            _SectionLabel(label: l.sectionGeneral),
            const SizedBox(height: 8),
            _SettingsCard(
              children: [
                _DarkSwitchTile(
                  title: l.keepScreenOn,
                  subtitle: l.keepScreenOnSub,
                  value: settings.keepScreenOn,
                  onChanged: (v) => controller
                      .updateSettings(settings.copyWith(keepScreenOn: v)),
                ),
                _CardDivider(),
                _DarkSwitchTile(
                  title: l.progressBar,
                  subtitle: l.progressBarSub,
                  value: settings.showProgressBar,
                  onChanged: (v) => controller
                      .updateSettings(settings.copyWith(showProgressBar: v)),
                ),
                _CardDivider(),
                _DarkSwitchTile(
                  title: l.timerSignal,
                  subtitle: l.timerSignalSub,
                  value: settings.timerSignalEnabled,
                  onChanged: (v) => controller
                      .updateSettings(settings.copyWith(timerSignalEnabled: v)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Prestart section ───────────────────────────────────────────
            _SectionLabel(label: l.sectionPrestart),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                l.prestartSub,
                style: const TextStyle(color: _kTextSub, fontSize: 12),
              ),
            ),
            _SettingsCard(
              children: [
                _PrestartStepper(
                  seconds: settings.prestartSeconds,
                  onChanged: (v) => controller
                      .updateSettings(settings.copyWith(prestartSeconds: v)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Tick sound section ─────────────────────────────────────────
            _SectionLabel(label: l.sectionTickSound),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                l.tickSoundSub,
                style: const TextStyle(color: _kTextSub, fontSize: 12),
              ),
            ),
            _SettingsCard(
              children: [
                for (final id in TimerController.tickSoundIds) ...[
                  _SoundRadioTile(
                    id: id,
                    label: l.soundName(id),
                    groupValue: settings.tickSoundId,
                    accentColor: _kAccent,
                    onSelect: (value) => controller.previewTickSound(value),
                    onPreview: () => controller.previewTickSound(id),
                  ),
                  if (id != TimerController.tickSoundIds.last) _CardDivider(),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // ── Done fanfare section ───────────────────────────────────────
            _SectionLabel(label: l.sectionDoneFanfare),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                l.doneFanfareSub,
                style: const TextStyle(color: _kTextSub, fontSize: 12),
              ),
            ),
            _SettingsCard(
              children: [
                for (final id in TimerController.doneSoundIds) ...[
                  _SoundRadioTile(
                    id: id,
                    label: l.soundName(id),
                    groupValue: settings.doneSoundId,
                    accentColor: const Color(0xFF9D4EDD),
                    onSelect: (value) => controller.previewDoneSound(value),
                    onPreview: () => controller.previewDoneSound(id),
                  ),
                  if (id != TimerController.doneSoundIds.last) _CardDivider(),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // ── Backup section ─────────────────────────────────────────────
            _SectionLabel(label: l.sectionLanguage),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                l.languageSub,
                style: const TextStyle(color: _kTextSub, fontSize: 12),
              ),
            ),
            _SettingsCard(
              children: [
                for (final code in _languageCodes) ...[
                  _LanguageTile(
                    code: code,
                    groupValue: settings.languageCode,
                    onSelect: (value) => controller.updateSettings(
                        settings.copyWith(languageCode: value)),
                  ),
                  if (code != _languageCodes.last) _CardDivider(),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // ── Backup section ─────────────────────────────────────────────
            _SectionLabel(label: l.sectionBackup),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                l.backupSub,
                style: const TextStyle(color: _kTextSub, fontSize: 12),
              ),
            ),
            const _BackupSection(),
          ],
        ),
      ),
    );
  }
}

// ── Section label ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 0),
      child: Text(
        label,
        style: const TextStyle(
          color: _kTextSub,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

// ── Card container ─────────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

// ── Card divider ───────────────────────────────────────────────────────────

class _CardDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: _kDivider,
    );
  }
}

// ── Dark switch tile ───────────────────────────────────────────────────────

class _DarkSwitchTile extends StatelessWidget {
  const _DarkSwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: _kTextPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        color: _kTextSub, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: _kAccent,
            activeTrackColor: _kAccent.withValues(alpha: 0.25),
            inactiveThumbColor: _kTextSub,
            inactiveTrackColor: _kSurfaceHigh,
          ),
        ],
      ),
    );
  }
}

// ── Sound radio tile ───────────────────────────────────────────────────────

class _SoundRadioTile extends StatelessWidget {
  const _SoundRadioTile({
    required this.id,
    required this.label,
    required this.groupValue,
    required this.accentColor,
    required this.onSelect,
    required this.onPreview,
  });

  final String id;
  final String label;
  final String groupValue;
  final Color accentColor;
  final ValueChanged<String> onSelect;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final selected = id == groupValue;

    return GestureDetector(
      onTap: () => onSelect(id),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Custom radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? accentColor : _kTextSub,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accentColor,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: selected ? _kTextPrimary : _kTextSub,
                  fontSize: 15,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            // Play preview button
            GestureDetector(
              onTap: onPreview,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.play_arrow_rounded,
                    color: accentColor, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Prestart stepper ───────────────────────────────────────────────────────

class _PrestartStepper extends StatelessWidget {
  const _PrestartStepper({required this.seconds, required this.onChanged});

  final int seconds;
  final ValueChanged<int> onChanged;

  static const int _min = AppSettings.minPrestartSeconds;
  static const int _max = AppSettings.maxPrestartSeconds;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _PrestartBtn(label: '-5', delta: -5, current: seconds, onChanged: onChanged),
          _PrestartBtn(label: '-1', delta: -1, current: seconds, onChanged: onChanged),
          Expanded(
            child: Column(
              children: [
                Text(
                  seconds == 0 ? context.l10n.prestartOff : '$seconds',
                  style: const TextStyle(
                    color: _kTextPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  seconds == 0
                      ? context.l10n.prestartInstant
                      : context.l10n.unitSec,
                  style: const TextStyle(
                    color: _kTextSub,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _PrestartBtn(label: '+1', delta: 1, current: seconds, onChanged: onChanged),
          _PrestartBtn(label: '+5', delta: 5, current: seconds, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _PrestartBtn extends StatelessWidget {
  const _PrestartBtn({
    required this.label,
    required this.delta,
    required this.current,
    required this.onChanged,
  });

  final String label;
  final int delta;
  final int current;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final target = (current + delta)
        .clamp(_PrestartStepper._min, _PrestartStepper._max);
    final enabled = target != current;
    final isNegative = delta < 0;
    final fg = isNegative ? kDanger : _kAccent;
    final bg = isNegative ? kDangerDim : _kAccent.withValues(alpha: 0.12);

    return GestureDetector(
      onTap: enabled
          ? () {
              HapticFeedback.lightImpact();
              onChanged(target);
            }
          : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.3,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Backup section ─────────────────────────────────────────────────────────

class _BackupSection extends StatefulWidget {
  const _BackupSection();

  @override
  State<_BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends State<_BackupSection> {
  bool _busy = false;

  void _toast(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: error ? const Color(0xFF4A1F1F) : _kSurfaceHigh,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: error ? 6 : 4),
      ));
  }

  Future<void> _export() async {
    if (_busy) return;
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      final controller = context.read<TimerController>();
      final bytes = controller.createBackup();
      final count = controller.history.length;

      final uri = await FilePicker.saveFile(
        dialogTitle: l.dialogSaveBackup,
        fileName: BackupService.suggestedFileName(DateTime.now()),
        bytes: bytes,
        mimeType: 'application/zip',
      );

      if (uri == null) {
        _toast(l.exportCancelled);
        return;
      }
      _toast(l.backupSaved(count));
    } catch (e) {
      _toast(l.backupSaveFailed('$e'), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    if (_busy) return;
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      final picked = await FilePicker.pickFile(
        dialogTitle: l.dialogChooseBackup,
        type: FileType.custom,
        allowedExtensions: const ['zip'],
      );
      if (picked == null) {
        _toast(l.importCancelled);
        return;
      }

      final Uint8List bytes = await picked.readAsBytes();
      // Parse first, so an unreadable file is rejected before anything changes.
      final preview = BackupService.read(bytes);

      if (!mounted) return;
      final confirmed = await _confirmRestore(preview);
      if (confirmed != true) {
        _toast(l.importCancelled);
        return;
      }

      if (!mounted) return;
      await context.read<TimerController>().restoreBackup(bytes);
      final count = preview.history.length;
      _toast(l.backupRestored(count));
    } on BackupFormatException catch (e) {
      _toast(e.message, error: true);
    } catch (e) {
      _toast(l.backupReadFailed('$e'), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool?> _confirmRestore(BackupContents preview) {
    final l = context.l10n;
    final current = context.read<TimerController>().history.length;
    final incoming = preview.history.length;
    final exported = preview.exportedAt;

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _kSurface,
        title: Text(l.restoreDialogTitle,
            style: const TextStyle(color: _kTextPrimary, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exported == null
                  ? l.backupContents
                  : l.backedUpOn(
                      DateFormat('d MMM yyyy, HH:mm').format(exported),
                      preview.appVersion == null
                          ? ''
                          : ' (v${preview.appVersion})'),
              style: const TextStyle(color: _kTextSub, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Text(
              '${l.bulletWorkouts(incoming)}\n${l.bulletAllSettings}',
              style: const TextStyle(color: _kTextPrimary, fontSize: 14),
            ),
            const SizedBox(height: 14),
            Text(
              current == 0
                  ? l.replaceWarningEmpty
                  : l.replaceWarning(current),
              style: const TextStyle(color: kDanger, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.actionCancel,
                style: const TextStyle(color: _kTextSub)),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.actionReplace,
                style: const TextStyle(
                    color: kDanger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workouts = context.watch<TimerController>().history.length;
    final l = context.l10n;

    return _SettingsCard(
      children: [
        _BackupTile(
          icon: Icons.save_alt_rounded,
          title: l.exportBackup,
          subtitle: workouts == 0
              ? l.exportSubtitleEmpty
              : l.exportSubtitle(workouts),
          accentColor: _kAccent,
          busy: _busy,
          onTap: _export,
        ),
        _CardDivider(),
        _BackupTile(
          icon: Icons.settings_backup_restore_rounded,
          title: l.importBackup,
          subtitle: l.importBackupSub,
          accentColor: const Color(0xFFFFA62B),
          busy: _busy,
          onTap: _import,
        ),
      ],
    );
  }
}

class _BackupTile extends StatelessWidget {
  const _BackupTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.busy,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: busy
          ? null
          : () {
              HapticFeedback.lightImpact();
              onTap();
            },
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: busy ? 0.4 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: _kTextPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: const TextStyle(color: _kTextSub, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded,
                  color: _kTextSub.withValues(alpha: 0.6), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Language picker ────────────────────────────────────────────────────────

/// '' is "follow the system"; the rest are the translated locales.
const List<String> _languageCodes = <String>[
  '', ...AppSettings.supportedLanguageCodes,
];

/// Languages are listed in their own language, never translated: someone who
/// has the app stuck in a language they cannot read still needs to find their
/// own on this list.
const Map<String, String> _languageEndonyms = <String, String>{
  'en': 'English',
  'de': 'Deutsch',
  'fr': 'Français',
  'es': 'Español',
  'ru': 'Русский',
  'ka': 'ქართული',
};

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.code,
    required this.groupValue,
    required this.onSelect,
  });

  final String code;
  final String groupValue;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final selected = code == groupValue;
    final name = code.isEmpty
        ? context.l10n.languageSystem
        : _languageEndonyms[code] ?? code;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onSelect(code);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? _kAccent : _kTextSub,
              size: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: selected ? _kAccent : _kTextPrimary,
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
