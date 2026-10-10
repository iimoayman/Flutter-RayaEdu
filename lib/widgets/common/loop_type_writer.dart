import 'dart:async';

import 'package:flutter/foundation.dart';

/// Mirrors the Kotlin `LoopingTypeWriter` class.
///
/// Behaviour per string:
///   1. Type it forward one char at a time (delay = [typingDelay]).
///   2. Once complete, pause for [pauseDelay].
///   3. Delete it backward one char at a time (delay = [typingDelay] / 2).
///   4. Move to the next string and repeat.
class LoopTypeWriter {
  LoopTypeWriter({
    required this.notifier,
    required this.strings,
    this.typingDelay = const Duration(milliseconds: 500),
    this.pauseDelay = const Duration(milliseconds: 400),
  });

  /// Where the animated text is written to (instead of Android's `TextView`).
  final ValueNotifier<String> notifier;

  /// List of strings to cycle through (mirrors `texts: List<String>`).
  final List<String> strings;

  /// Delay between each typed character (mirrors `typingDelay`).
  final Duration typingDelay;

  /// Delay after a string is fully typed, before deletion starts
  /// (mirrors `pauseDelay`).
  final Duration pauseDelay;

  Timer? _timer;
  int _textIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;

  /// Mirrors `fun start()` — resets state and begins the loop.
  void start() {
    stop();
    _textIndex = 0;
    _charIndex = 0;
    _isDeleting = false;
    notifier.value = '';
    _tick();
  }

  /// Mirrors `fun stop()` — removes all pending callbacks.
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Mirrors the inner `runnable.run()` body in Kotlin.
  void _tick() {
    if (strings.isEmpty) return;

    final current = strings[_textIndex];

    if (!_isDeleting) {
      // ── Typing forward ────────────────────────────────
      if (_charIndex < current.length) {
        _charIndex++;
        notifier.value = current.substring(0, _charIndex);
        _timer = Timer(typingDelay, _tick);
      } else {
        // Fully typed → start deleting after pause
        _isDeleting = true;
        _timer = Timer(pauseDelay, _tick);
      }
    } else {
      // ── Deleting backward ─────────────────────────────
      if (_charIndex > 0) {
        _charIndex--;
        notifier.value = current.substring(0, _charIndex);
        _timer = Timer(
          Duration(milliseconds: typingDelay.inMilliseconds ~/ 2),
          _tick,
        );
      } else {
        // Fully deleted → move to next string
        _isDeleting = false;
        _textIndex = (_textIndex + 1) % strings.length;
        _timer = Timer(typingDelay, _tick);
      }
    }
  }
}