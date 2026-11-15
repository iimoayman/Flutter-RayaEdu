import 'package:flutter/material.dart';
import '../../../../data/models/service_models.dart';
import '../../../../domain/repositories/student_repository.dart';

class NotificationsViewModel with ChangeNotifier {
  final StudentRepository repository;

  List<Notifications> _sessions = [];
  List<MyWarnings> _warnings = [];
  bool _isLoading = false;
  int _unreadCount = 2;

  NotificationsViewModel(this.repository) {
    loadNotifications();
  }

  List<Notifications> get sessions => _sessions;
  List<MyWarnings> get warnings => _warnings;
  bool get isLoading => _isLoading;
  int get unreadCount => _unreadCount;

  void markAllRead() {
    _unreadCount = 0;
    notifyListeners();
  }

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res1 = await repository.getAlerts();
      final res2 = await repository.getWarnings();

      if (res1.success && res1.data != null) {
        _sessions = res1.data!;
      }
      if (res2.success && res2.data != null) {
        _warnings = res2.data!;
      }
    } catch (_) {
      // Fallback
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
