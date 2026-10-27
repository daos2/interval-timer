import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _kBg,
        appBar: AppBar(
          backgroundColor: _kBg,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Settings',
            style: TextStyle(
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
            const _SectionLabel(label: 'GENERAL'),
            const SizedBox(height: 8),
            _SettingsCard(
              children: [
                _DarkSwitchTile(
                  title: 'Keep screen on',
                  subtitle: 'Prevent display sleep while timer is running',
                  value: settings.keepScreenOn,
                  onChanged: (v) => controller
                      .updateSettings(settings.copyWith(keepScreenOn: v)),
                ),
                _CardDivider(),
                _DarkSwitchTile(
                  title: 'Progress bar',
                  subtitle: 'Show or hide total completion progress',
                  value: settings.showProgressBar,
                  onChanged: (v) => controller
                      .updateSettings(settings.copyWith(showProgressBar: v)),
                ),
                _CardDivider(),
                _DarkSwitchTile(
                  title: 'Timer signal',
                  subtitle: 'Play signal at every workout unit',
                  value: settings.timerSignalEnabled,
                  onChanged: (v) => controller
                      .updateSettings(settings.copyWith(timerSignalEnabled: v)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Prestart section ───────────────────────────────────────────
            const _SectionLabel(label: 'PRESTART'),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                'Countdown before the first interval — set 0 to start instantly',
                style: TextStyle(color: _kTextSub, fontSize: 12),
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
            const _SectionLabel(label: 'TICK SOUND'),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                'Plays at every workout unit — choose one of 6 short clicks',
                style: TextStyle(color: _kTextSub, fontSize: 12),
              ),
            ),
            _SettingsCard(
              children: [
                for (final entry
                    in TimerController.tickSoundOptions.entries) ...[
                  _SoundRadioTile(
                    id: entry.key,
                    label: entry.value,
                    groupValue: settings.tickSoundId,
                    accentColor: _kAccent,
                    onSelect: (id) => controller.previewTickSound(id),
                    onPreview: () =>
                        controller.previewTickSound(entry.key),
                  ),
                  if (entry.key !=
                      TimerController.tickSoundOptions.keys.last)
                    _CardDivider(),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // ── Done fanfare section ───────────────────────────────────────
            const _SectionLabel(label: 'DONE FANFARE'),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                'Plays at the end of all periods — choose one of 3 fanfares',
                style: TextStyle(color: _kTextSub, fontSize: 12),
              ),
            ),
            _SettingsCard(
              children: [
                for (final entry
                    in TimerController.doneSoundOptions.entries) ...[
                  _SoundRadioTile(
                    id: entry.key,
                    label: entry.value,
                    groupValue: settings.doneSoundId,
                    accentColor: const Color(0xFF9D4EDD),
                    onSelect: (id) => controller.previewDoneSound(id),
                    onPreview: () =>
                        controller.previewDoneSound(entry.key),
                  ),
                  if (entry.key !=
                      TimerController.doneSoundOptions.keys.last)
                    _CardDivider(),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // ── Backup section ─────────────────────────────────────────────
            const _SectionLabel(label: 'BACKUP'),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                'Save settings and workout history to a .zip file, or restore '
                'them from one',
                style: TextStyle(color: _kTextSub, fontSize: 12),
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
                  seconds == 0 ? 'Off' : '$seconds',
                  style: const TextStyle(
                    color: _kTextPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  seconds == 0 ? 'instant' : 'sec',
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
    setState(() => _busy = true);
    try {
      final controller = context.read<TimerController>();
      final bytes = controller.createBackup();
      final count = controller.history.length;

      final uri = await FilePicker.saveFile(
        dialogTitle: 'Save Interval Timer backup',
        fileName: BackupService.suggestedFileName(DateTime.now()),
        bytes: bytes,
        mimeType: 'application/zip',
      );

      if (uri == null) {
        _toast('Export cancelled.');
        return;
      }
      _toast('Backup saved — $count '
          '${count == 1 ? 'workout' : 'workouts'} and your settings.');
    } catch (e) {
      _toast('Could not save the backup: $e', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final picked = await FilePicker.pickFile(
        dialogTitle: 'Choose an Interval Timer backup',
        type: FileType.custom,
        allowedExtensions: const ['zip'],
      );
      if (picked == null) {
        _toast('Import cancelled.');
        return;
      }

      final Uint8List bytes = await picked.readAsBytes();
      // Parse first, so an unreadable file is rejected before anything changes.
      final preview = BackupService.read(bytes);

      if (!mounted) return;
      final confirmed = await _confirmRestore(preview);
      if (confirmed != true) {
        _toast('Import cancelled.');
        return;
      }

      if (!mounted) return;
      await context.read<TimerController>().restoreBackup(bytes);
      final count = preview.history.length;
      _toast('Restored $count '
          '${count == 1 ? 'workout' : 'workouts'} and your settings.');
    } on BackupFormatException catch (e) {
      _toast(e.message, error: true);
    } catch (e) {
      _toast('Could not read that backup: $e', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool?> _confirmRestore(BackupContents preview) {
    final current = context.read<TimerController>().history.length;
    final incoming = preview.history.length;
    final exported = preview.exportedAt;

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _kSurface,
        title: const Text('Restore this backup?',
            style: TextStyle(color: _kTextPrimary, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exported == null
                  ? 'Backup contents:'
                  : 'Backed up ${DateFormat('d MMM yyyy, HH:mm').format(exported)}'
                      '${preview.appVersion == null ? '' : ' (v${preview.appVersion})'}:',
              style: const TextStyle(color: _kTextSub, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Text(
              '• $incoming ${incoming == 1 ? 'workout' : 'workouts'}\n'
              '• All app settings',
              style: const TextStyle(color: _kTextPrimary, fontSize: 14),
            ),
            const SizedBox(height: 14),
            Text(
              current == 0
                  ? 'This replaces your current settings. You have no saved '
                      'workouts to lose.'
                  : 'This replaces your current settings and all $current '
                      'saved ${current == 1 ? 'workout' : 'workouts'}. '
                      'That cannot be undone.',
              style: const TextStyle(color: kDanger, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel', style: TextStyle(color: _kTextSub)),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Replace',
                style: TextStyle(color: kDanger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workouts = context.watch<TimerController>().history.length;

    return _SettingsCard(
      children: [
        _BackupTile(
          icon: Icons.save_alt_rounded,
          title: 'Export backup',
          subtitle: workouts == 0
              ? 'Save your settings to a .zip file'
              : 'Save your settings and $workouts '
                  '${workouts == 1 ? 'workout' : 'workouts'} to a .zip file',
          accentColor: _kAccent,
          busy: _busy,
          onTap: _export,
        ),
        _CardDivider(),
        _BackupTile(
          icon: Icons.settings_backup_restore_rounded,
          title: 'Import backup',
          subtitle: 'Replace settings and history from a .zip file',
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
