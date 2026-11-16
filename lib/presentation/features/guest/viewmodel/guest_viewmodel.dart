import 'package:flutter/material.dart';
import '../../../../data/models/student_models.dart';
import '../../../../domain/repositories/student_repository.dart';

class AcademicProgramModel {
  final String titleKey;
  final String detailsKey;
  final String iconAsset;
  final String detailImageAsset;

  AcademicProgramModel({
    required this.titleKey,
    required this.detailsKey,
    required this.iconAsset,
    required this.detailImageAsset,
  });
}

class DoctorModel {
  final String name;
  final String department;
  final String academicRank;

  DoctorModel({
    required this.name,
    required this.department,
    required this.academicRank,
  });
}

class GuestViewModel with ChangeNotifier {
  final StudentRepository repository;

  List<Order> _bannersOne = [];
  List<Order> _bannersTwo = [];
  bool _isLoading = false;
  AcademicProgramModel? _selectedProgram;

  GuestViewModel(this.repository) {
    loadData();
  }

  List<Order> get bannersOne => _bannersOne;
  List<Order> get bannersTwo => _bannersTwo;
  bool get isLoading => _isLoading;
  AcademicProgramModel? get selectedProgram => _selectedProgram;

  final List<AcademicProgramModel> programs = [
    AcademicProgramModel(
      titleKey: 'bisName',
      detailsKey: 'BisDetails',
      iconAsset: 'assets/images/cpu.webp',
      detailImageAsset: 'assets/images/bis_img.jpg',
    ),
    AcademicProgramModel(
      titleKey: 'ACCname',
      detailsKey: 'ACCDetails',
      iconAsset: 'assets/images/accounting.webp',
      detailImageAsset: 'assets/images/acc_img.jpg',
    ),
    AcademicProgramModel(
      titleKey: 'TradeName',
      detailsKey: 'TradeDetails',
      iconAsset: 'assets/images/port.webp',
      detailImageAsset: 'assets/images/trade_img.jpg',
    ),
  ];

  final List<DoctorModel> crewList = [
    DoctorModel(name: 'م.د/ محمد علي الزواوي', department: 'رئيس مجلس الإدارة', academicRank: ''),
    DoctorModel(name: 'أ.د/ محمد إسماعيل عبدالله', department: 'رئيس لجنة الحكماء', academicRank: 'أستاذ'),
    DoctorModel(name: 'أ.د/ مني الحسيني عمار', department: 'العميدة', academicRank: 'أستاذ'),
    DoctorModel(name: 'د/ السيد يوسف حراز', department: 'إدارة أعمال', academicRank: 'أستاذ مساعد'),
    DoctorModel(name: 'د/ تامر محمد موسى', department: 'إدارة أعمال', academicRank: 'أستاذ مساعد'),
    DoctorModel(name: 'د/ إلهام محمد حامد', department: 'قانون', academicRank: 'مدرس'),
    DoctorModel(name: 'د/ رغداء محمد حلمي', department: 'إدارة أعمال', academicRank: 'مدرس'),
    DoctorModel(name: 'د/ محمد أيمن الجوجري', department: 'اقتصاد', academicRank: 'مدرس'),
    DoctorModel(name: 'د/ أسامه محمد التابعي الدنون', department: 'محاسبة', academicRank: 'مدرس'),
    DoctorModel(name: 'د/ أحمد سليمان السعيد', department: 'إدارة أعمال', academicRank: 'مدرس'),
    DoctorModel(name: 'د/ أسماء علياء البدوي', department: 'إدارة أعمال', academicRank: 'مدرس'),
    DoctorModel(name: 'د/ شادي محمد عبد العزيز', department: 'إدارة أعمال', academicRank: 'مدرس'),
    DoctorModel(name: 'د/ طارق السيد البراشي', department: 'اقتصاد', academicRank: 'مدرس'),
    DoctorModel(name: 'د/ أسامه محمد البربري', department: 'محاسبة', academicRank: 'مدرس'),
    DoctorModel(name: 'د/ مروه بديع عاشور', department: 'إدارة أعمال', academicRank: 'مدرس'),
    DoctorModel(name: 'د/ أحمد مصطفى عبدالله', department: 'إدارة أعمال', academicRank: 'مدرس'),
    DoctorModel(name: 'د/ آية هشام أبو الفتوح', department: 'قانون', academicRank: 'مدرس'),
    DoctorModel(name: 'د/ محمد محمود برهام', department: 'اقتصاد', academicRank: 'مدرس'),
  ];

  void selectProgram(AcademicProgramModel program) {
    _selectedProgram = program;
    notifyListeners();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _bannersOne = await repository.getGuestBanners();
      _bannersTwo = await repository.getGuestBannersSecond();
    } catch (_) {
      // Fallback
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
