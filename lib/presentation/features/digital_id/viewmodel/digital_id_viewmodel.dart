import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/shake_detector.dart';
import '../../../../data/models/student_models.dart';
import '../../../../domain/repositories/student_repository.dart';

class DigitalIdViewModel with ChangeNotifier {
  final StudentRepository repository;

  MyData? _studentData;
  bool _isLoading = false;
  bool _isSendingProblem = false;
  late final ShakeDetector shakeDetector;
  VoidCallback? onShakeDetected;

  DigitalIdViewModel(this.repository) {
    loadStudentData();
    shakeDetector = ShakeDetector(
      onShake: () {
        onShakeDetected?.call();
      },
    );
  }

  MyData? get studentData => _studentData;
  bool get isLoading => _isLoading;
  bool get isSendingProblem => _isSendingProblem;

  Future<void> loadStudentData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await repository.getMyData();
      if (res.success && res.data != null) {
        _studentData = res.data;
      }
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendProblemReport(String message) async {
    _isSendingProblem = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('problems').add({
        'message': message,
        'student_code': _studentData?.code,
        'student_name': _studentData?.name,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _isSendingProblem = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isSendingProblem = false;
      notifyListeners();
      return false;
    }
  }

  void startSensors() {
    shakeDetector.startListening();
  }

  void stopSensors() {
    shakeDetector.stopListening();
  }
}
