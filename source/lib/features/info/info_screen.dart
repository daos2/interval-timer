// "About & Support" -- what the app is for, and how to tip the developer.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/l10n_ext.dart';
import '../../theme.dart';
import '../backup/backup_service.dart';
import 'donation.dart';

// ── The "I" button that lives in the Timer app bar ─────────────────────────

/// Pulsing info badge. The ring is a slow outward ping rather than a blink:
/// it has to read as "there is something here" from the corner of the eye
/// without competing with a running workout for attention.
///
/// The pulse is suppressed when the platform asks for reduced motion.
class InfoButton extends StatefulWidget {
  const InfoButton({super.key});

  @override
  State<InfoButton> createState() => _InfoButtonState();
}

class _InfoButtonState extends State<InfoButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  bool _animate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Android's "Remove animations" accessibility switch lands here.
    final wanted = !MediaQuery.disableAnimationsOf(context);
    if (wanted == _animate) return;
    _animate = wanted;
    if (wanted) {
      _pulse.repeat();
    } else {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _open() {
    HapticFeedback.selectionClick();
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const InfoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.infoBadgeSemantics,
      child: InkResponse(
        onTap: _open,
        radius: 24,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: _Ping(
              pulse: _pulse,
              animate: _animate,
              child: const _InfoBadge(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Separated so the badge itself is rebuilt once, not on every pulse frame.
class _Ping extends StatelessWidget {
  const _Ping({
    required this.pulse,
    required this.animate,
    required this.child,
  });

  final Animation<double> pulse;
  final bool animate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (context, badge) {
        final t = pulse.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            if (animate)
              Opacity(
                opacity: (1 - t) * 0.5,
                child: Container(
                  width: 26 + 20 * t,
                  height: 26 + 20 * t,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kAccent, width: 1.4),
                  ),
                ),
              ),
            badge!,
          ],
        );
      },
      child: child,
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kAccent.withValues(alpha: 0.14),
        border: Border.all(color: kAccent, width: 1.5),
      ),
      child: const Text(
        'I',
        style: TextStyle(
          color: kAccent,
          fontSize: 14,
          height: 1,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ── The screen itself ──────────────────────────────────────────────────────

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  DonationNetwork _network = DonationNetwork.bitcoin;

  void _select(DonationNetwork network) {
    if (network == _network) return;
    HapticFeedback.selectionClick();
    setState(() => _network = network);
  }

  Future<void> _copy(DonationTarget target) async {
    final message = context.l10n.addressCopied(target.name);
    await Clipboard.setData(ClipboardData(text: target.address));
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: kSurfaceHigh,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final target = donationTargetFor(_network);
    final l = context.l10n;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        iconTheme: const IconThemeData(color: kTextPrimary),
        title: Text(
          l.infoTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: kTextPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          const _PurposeCard(),
          const SizedBox(height: 22),
          _SectionLabel(l.supportDevelopment),
          const SizedBox(height: 10),
          Text(
            l.supportIntro,
            style: const TextStyle(
                color: kTextSub, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 16),
          _NetworkSwitch(selected: _network, onSelect: _select),
          const SizedBox(height: 18),
          _QrPanel(target: target),
          const SizedBox(height: 18),
          _AddressPanel(target: target, onCopy: () => _copy(target)),
          const SizedBox(height: 20),
          Text(
            l.networkWarning,
            style: const TextStyle(
                color: kTextSub, fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'Interval Timer ${BackupService.appVersion}',
              style: TextStyle(color: kTextSub, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: kTextSub,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      );
}

class _PurposeCard extends StatelessWidget {
  const _PurposeCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.whatThisAppIsFor,
            style: const TextStyle(
              color: kTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l.purposeIntro,
            style: const TextStyle(
                color: kTextSub, fontSize: 13, height: 1.55),
          ),
          const SizedBox(height: 12),
          _Bullet(l.purposeBullet1),
          _Bullet(l.purposeBullet2),
          _Bullet(l.purposeBullet3),
          _Bullet(l.purposeBullet4),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7, right: 10),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: kAccent,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: kTextSub,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Three-way network picker. Each button is `Expanded` with a scaled-down
/// label, so the row cannot overflow however wide the captions get.
class _NetworkSwitch extends StatelessWidget {
  const _NetworkSwitch({required this.selected, required this.onSelect});

  final DonationNetwork selected;
  final ValueChanged<DonationNetwork> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (final target in kDonationTargets)
            Expanded(
              child: GestureDetector(
                onTap: () => onSelect(target.network),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: target.network == selected
                        ? kAccent.withValues(alpha: 0.16)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      target.tab,
                      maxLines: 1,
                      style: TextStyle(
                        color: target.network == selected
                            ? kAccent
                            : kTextSub,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The QR itself. The asset is cropped to the white card with no frame of its
/// own, so a plain white rounded panel is all that is needed -- the image
/// background and the panel are the same white and the seam disappears.
class _QrPanel extends StatelessWidget {
  const _QrPanel({required this.target});
  final DonationTarget target;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: AspectRatio(
              aspectRatio: 1,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                // AnimatedSwitcher stacks its children loosely, so without
                // this the panel would shrink-wrap the QR and inherit its
                // pixel size instead of filling the square.
                child: SizedBox.expand(
                  key: ValueKey(target.network),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Image.asset(
                      target.qrAsset,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                      semanticLabel:
                          context.l10n.qrSemantics(target.name),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${target.name}  ·  ${_chainLabel(context, target)}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: kTextPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _AddressPanel extends StatelessWidget {
  const _AddressPanel({required this.target, required this.onCopy});

  final DonationTarget target;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SelectableText(
            target.address,
            style: const TextStyle(
              color: kTextPrimary,
              fontSize: 13,
              height: 1.6,
              fontFamily: 'monospace',
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              onPressed: onCopy,
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccent,
                foregroundColor: kBg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: Text(
                context.l10n.actionCopy,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Only Bitcoin's chain line is prose; ERC20 and BEP20 are standard names
/// that stay as they are in every language.
String _chainLabel(BuildContext context, DonationTarget target) =>
    target.network == DonationNetwork.bitcoin
        ? context.l10n.chainBitcoin
        : target.chain;
