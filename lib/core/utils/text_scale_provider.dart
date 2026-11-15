import 'package:flutter/material.dart';
import '../../data/datasources/local_datasource.dart';

class TextScaleProvider with ChangeNotifier {
  final LocalDataSource localDataSource;
  double _scale = 1.0;

  TextScaleProvider(this.localDataSource) {
    _loadScale();
  }

  double get scale => _scale;

  Future<void> _loadScale() async {
    _scale = await localDataSource.getTextScale();
    notifyListeners();
  }

  Future<void> setScale(double newScale) async {
    _scale = newScale.clamp(0.85, 1.3);
    await localDataSource.saveTextScale(_scale);
    notifyListeners();
  }
}
