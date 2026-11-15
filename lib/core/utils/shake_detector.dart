import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetector {
  final VoidCallback onShake;
  final double shakeThresholdGravity;
  final int minTimeBetweenShakesMs;

  StreamSubscription? _subscription;
  int _lastShakeTime = 0;

  ShakeDetector({
    required this.onShake,
    this.shakeThresholdGravity = 2.7,
    this.minTimeBetweenShakesMs = 1200,
  });

  void startListening() {
    _subscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      final gX = event.x / 9.80665;
      final gY = event.y / 9.80665;
      final gZ = event.z / 9.80665;

      final gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

      if (gForce > shakeThresholdGravity) {
        final now = DateTime.now().millisecondsSinceEpoch;
        if (_lastShakeTime + minTimeBetweenShakesMs > now) return;

        _lastShakeTime = now;
        onShake();
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
  }
}
