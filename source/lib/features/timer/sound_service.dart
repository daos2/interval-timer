import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

/// Generates sine-wave tones at runtime (no asset files required) and plays
/// them via [AudioPlayer] using [BytesSource]. All tick sounds ≤ 250 ms.
class SoundService {
  static const int _sampleRate = 44100;

  // Created on first use so the plugin is not touched during app start-up.
  AudioPlayer? _tickPlayerRef;
  AudioPlayer? _donePlayerRef;

  AudioPlayer get _tickPlayer => _tickPlayerRef ??= AudioPlayer();
  AudioPlayer get _donePlayer => _donePlayerRef ??= AudioPlayer();

  Future<void> dispose() async {
    await _tickPlayerRef?.dispose();
    await _donePlayerRef?.dispose();
    _tickPlayerRef = null;
    _donePlayerRef = null;
  }

  /// Playback is a cue, never a reason to interrupt a running workout.
  Future<void> _play(AudioPlayer player, Uint8List bytes) async {
    try {
      await player.stop();
      await player.play(BytesSource(bytes));
    } catch (_) {
      // Audio focus lost, no output device, etc. — carry on silently.
    }
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  Future<void> playTick(String soundId) async {
    final bytes = _buildTick(soundId);
    await _play(_tickPlayer, bytes);
  }

  /// Play a distinct marker sound for interval starts/ends.
  Future<void> playTickHigher(String _) async {
    final bytes = _buildMarker();
    await _play(_tickPlayer, bytes);
  }

  /// Play tick sound at 150% duration (lower pitch).
  Future<void> playTickLower(String soundId) async {
    final bytes = _buildTick(soundId, durationMultiplier: 1.5);
    await _play(_tickPlayer, bytes);
  }

  Future<void> playDone(String soundId) async {
    final bytes = _buildDone(soundId);
    await _play(_donePlayer, bytes);
  }

  // ── Interval Marker (Start/End) ───────────────────────────────────────────

  static Uint8List _buildMarker() {
    return _wav(_join([
      _tone(freq: 1200, ms: 80, amp: 0.6, attack: 0.01),
      _silence(40),
      _tone(freq: 1500, ms: 100, amp: 0.6, attack: 0.01),
    ]));
  }

  // ── Tick presets (all ≤ 250 ms) ───────────────────────────────────────────

  static Uint8List _buildTick(String id, {double durationMultiplier = 1.0}) {
    switch (id) {
      case 'tick1': // Soft click – single mellow pop, 70 ms
        return _wav(_tone(freq: 800, ms: (70 * durationMultiplier).round(), amp: 0.35));

      case 'tick2': // Double click – two quick tones, ~130 ms
        return _wav(_join([
          _tone(freq: 1000, ms: (55 * durationMultiplier).round(), amp: 0.40),
          _silence((20 * durationMultiplier).round()),
          _tone(freq: 1200, ms: (55 * durationMultiplier).round(), amp: 0.40),
        ]));

      case 'tick3': // Alert click – crisp high tone, 80 ms
        return _wav(_tone(freq: 1500, ms: (80 * durationMultiplier).round(), amp: 0.45));

      case 'tick4': // Punchy click – low snappy pop, 50 ms
        return _wav(_tone(freq: 600, ms: (50 * durationMultiplier).round(), amp: 0.55, attack: 0.02, release: 0.65));

      case 'tick5': // Triple click – three pops, ~185 ms
        return _wav(_join([
          _tone(freq: 900, ms: (45 * durationMultiplier).round(), amp: 0.40),
          _silence((20 * durationMultiplier).round()),
          _tone(freq: 900, ms: (45 * durationMultiplier).round(), amp: 0.40),
          _silence((20 * durationMultiplier).round()),
          _tone(freq: 1100, ms: (45 * durationMultiplier).round(), amp: 0.45),
        ]));

      case 'tick6': // Bright click – airy high tone, 60 ms
        return _wav(_tone(freq: 2000, ms: (60 * durationMultiplier).round(), amp: 0.28));

      default:
        return _buildTick('tick1', durationMultiplier: durationMultiplier);
    }
  }

  // ── Done presets ───────────────────────────────────────────────────────────

  static Uint8List _buildDone(String id) {
    switch (id) {
      case 'done1': // Classic fanfare – C E G C ascending
        return _wav(_join([
          _tone(freq: 523.25, ms: 180, amp: 0.50),
          _silence(20),
          _tone(freq: 659.25, ms: 180, amp: 0.50),
          _silence(20),
          _tone(freq: 783.99, ms: 180, amp: 0.50),
          _silence(20),
          _tone(freq: 1046.50, ms: 420, amp: 0.55, release: 0.55),
        ]));

      case 'done2': // Rising fanfare – pentatonic climb
        return _wav(_join([
          _tone(freq: 440.00, ms: 150, amp: 0.45),
          _silence(20),
          _tone(freq: 523.25, ms: 150, amp: 0.45),
          _silence(20),
          _tone(freq: 659.25, ms: 150, amp: 0.50),
          _silence(20),
          _tone(freq: 880.00, ms: 150, amp: 0.50),
          _silence(20),
          _tone(freq: 1046.50, ms: 380, amp: 0.55, release: 0.55),
        ]));

      case 'done3': // Bright finale – fast two-octave arpeggio
        return _wav(_join([
          _tone(freq: 523.25, ms: 110, amp: 0.45),
          _silence(15),
          _tone(freq: 659.25, ms: 110, amp: 0.45),
          _silence(15),
          _tone(freq: 783.99, ms: 110, amp: 0.45),
          _silence(15),
          _tone(freq: 1046.50, ms: 110, amp: 0.50),
          _silence(15),
          _tone(freq: 1318.51, ms: 380, amp: 0.55, release: 0.55),
        ]));

      default:
        return _buildDone('done1');
    }
  }

  // ── DSP helpers ────────────────────────────────────────────────────────────

  static Int16List _tone({
    required double freq,
    required int ms,
    double amp = 0.5,
    double attack = 0.05,
    double release = 0.35,
  }) {
    final n = (_sampleRate * ms / 1000).round();
    final attackN = (n * attack).round().clamp(1, n);
    final releaseN = (n * release).round().clamp(1, n);
    final sustainEnd = n - releaseN;
    final out = Int16List(n);
    for (var i = 0; i < n; i++) {
      final t = i / _sampleRate;
      double env;
      if (i < attackN) {
        env = i / attackN;
      } else if (i >= sustainEnd) {
        env = (n - i) / releaseN;
      } else {
        env = 1.0;
      }
      out[i] = (sin(2 * pi * freq * t) * amp * 32767 * env)
          .round()
          .clamp(-32768, 32767);
    }
    return out;
  }

  static Int16List _silence(int ms) =>
      Int16List((_sampleRate * ms / 1000).round());

  static Int16List _join(List<Int16List> parts) {
    final total = parts.fold<int>(0, (s, p) => s + p.length);
    final out = Int16List(total);
    var offset = 0;
    for (final p in parts) {
      out.setRange(offset, offset + p.length, p);
      offset += p.length;
    }
    return out;
  }

  static Uint8List _wav(Int16List samples) {
    final dataBytes = samples.length * 2;
    final bd = ByteData(44 + dataBytes);
    bd.setUint32(0, 0x52494646, Endian.big);
    bd.setUint32(4, 36 + dataBytes, Endian.little);
    bd.setUint32(8, 0x57415645, Endian.big);
    bd.setUint32(12, 0x666d7420, Endian.big);
    bd.setUint32(16, 16, Endian.little);
    bd.setUint16(20, 1, Endian.little);
    bd.setUint16(22, 1, Endian.little);
    bd.setUint32(24, _sampleRate, Endian.little);
    bd.setUint32(28, _sampleRate * 2, Endian.little);
    bd.setUint16(32, 2, Endian.little);
    bd.setUint16(34, 16, Endian.little);
    bd.setUint32(36, 0x64617461, Endian.big);
    bd.setUint32(40, dataBytes, Endian.little);
    for (var i = 0; i < samples.length; i++) {
      bd.setInt16(44 + i * 2, samples[i], Endian.little);
    }
    return bd.buffer.asUint8List();
  }
}
