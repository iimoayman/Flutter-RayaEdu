import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../common_widgets/status_dialogs.dart';
import '../../../navigation/app_routes.dart';
import '../viewmodel/admission_viewmodel.dart';

class FillDataTwoView extends StatefulWidget {
  const FillDataTwoView({Key? key}) : super(key: key);

  @override
  State<FillDataTwoView> createState() => _FillDataTwoViewState();
}

class _FillDataTwoViewState extends State<FillDataTwoView> {
  final _formKey = GlobalKey<FormState>();

  final _schoolController = TextEditingController();
  final _yearController = TextEditingController(text: '2025');
  final _totalController = TextEditingController();
  final _degreeController = TextEditingController();
  final _rateController = TextEditingController();
  final _seatNumberController = TextEditingController();
  final _passwordCoordinationController = TextEditingController();
  final _codeCoordinationController = TextEditingController();

  String? _selectedDepartment = '1';
  String? _selectedQualification;
  String? _selectedStatus = '4';

  final List<Map<String, String>> _departments = [
    {'value': '1', 'label': 'نظم معلومات الأعمال'},
    {'value': '2', 'label': 'المحاسبة والمراجعة'},
    {'value': '3', 'label': 'اقتصاديات التجارة الخارجية'},
  ];

  final List<Map<String, String>> _statuses = [
    {'value': '1', 'label': 'تنسيق مرشح'},
    {'value': '4', 'label': 'تنسيق مباشر'},
    {'value': '2', 'label': 'تحويل'},
    {'value': '3', 'label': 'تقديم مباشر'},
    {'value': '5', 'label': 'فرصة استثنائية'},
    {'value': '6', 'label': 'تحويل أعلى من الصف'},
  ];

  @override
  void initState() {
    super.initState();
    _totalController.addListener(_calculateRate);
    _degreeController.addListener(_calculateRate);
  }

  void _calculateRate() {
    final total = double.tryParse(_totalController.text.trim());
    final degree = double.tryParse(_degreeController.text.trim());

    if (total != null && degree != null && total > 0) {
      final percentage = (degree / total) * 100;
      _rateController.text = '${percentage.toStringAsFixed(2)}%';
    } else {
      _rateController.text = '';
    }
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _yearController.dispose();
    _totalController.dispose();
    _degreeController.dispose();
    _rateController.dispose();
    _seatNumberController.dispose();
    _passwordCoordinationController.dispose();
    _codeCoordinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdmissionViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final qualifications = viewModel.optionsData?.qualifications ?? [];

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(
          langCode == 'en' ? 'Academic Details (2/2)' : 'البيانات الدراسية (2/2)',
          style: AppTextStyles.cairoBold(fontSize: 17, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.backArrow, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Step Progress Indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.orangeLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.orangeBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'المرحلة 2 من 2',
                          style: AppTextStyles.cairoBold(fontSize: 11, color: AppColors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'بيانات المؤهل والتنسيق والقسم',
                        style: AppTextStyles.cairoBold(fontSize: 13, color: AppColors.orangeDark),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Form Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppDecorations.cardDecoration(context),
                  child: Column(
                    children: [
                      // Department Selection
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDepartment,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'القسم المراد الالتحاق به',
                          prefixIcon: const Icon(Icons.school_outlined, color: AppColors.primary, size: 20),
                        ),
                        items: _departments
                            .map((d) => DropdownMenuItem(
                                  value: d['value'],
                                  child: Text(d['label']!),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedDepartment = val),
                        validator: (val) => val == null ? 'يرجى تحديد القسم' : null,
                      ),
                      const SizedBox(height: 14),

                      // Qualification Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedQualification,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'المؤهل الدراسي الحاصل عليه',
                          prefixIcon: const Icon(Icons.history_edu_rounded, color: AppColors.primary, size: 20),
                        ),
                        items: qualifications
                            .map((q) => DropdownMenuItem(
                                  value: q.pk.toString(),
                                  child: Text(q.name),
                                ))
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedQualification = val),
                        validator: (val) => val == null ? 'يرجى اختيار المؤهل' : null,
                      ),
                      const SizedBox(height: 14),

                      // Admission Status Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedStatus,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'حالة القيد / الترشيح',
                          prefixIcon: const Icon(Icons.how_to_reg_outlined, color: AppColors.primary, size: 20),
                        ),
                        items: _statuses
                            .map((s) => DropdownMenuItem(
                                  value: s['value'],
                                  child: Text(s['label']!),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedStatus = val),
                      ),
                      const SizedBox(height: 14),

                      // School Name
                      TextFormField(
                        controller: _schoolController,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'المدرسة / المعهد المتخرج منه',
                          prefixIcon: const Icon(Icons.apartment_outlined, color: AppColors.primary, size: 20),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Graduation Year
                      TextFormField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'سنة التخرج',
                          prefixIcon: const Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 20),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Total & Degree Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _totalController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: AppDecorations.inputDecoration(
                                context: context,
                                hintText: 'المجموع الكلي',
                              ),
                              validator: (val) => val == null || val.trim().isEmpty ? 'مطلوب' : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _degreeController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: AppDecorations.inputDecoration(
                                context: context,
                                hintText: 'مجموع الطالب',
                              ),
                              validator: (val) => val == null || val.trim().isEmpty ? 'مطلوب' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Percentage
                      TextFormField(
                        controller: _rateController,
                        readOnly: true,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'النسبة المئوية المحسوبة',
                          prefixIcon: const Icon(Icons.percent_rounded, color: AppColors.orange, size: 20),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Seat Number
                      TextFormField(
                        controller: _seatNumberController,
                        keyboardType: TextInputType.number,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'رقم الجلوس',
                          prefixIcon: const Icon(Icons.tag_rounded, color: AppColors.primary, size: 20),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Coordination Password
                      TextFormField(
                        controller: _passwordCoordinationController,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'الرقم السري للتنسيق',
                          prefixIcon: const Icon(Icons.vpn_key_outlined, color: AppColors.primary, size: 20),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Coordination Code
                      TextFormField(
                        controller: _codeCoordinationController,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'كود التنسيق الإلكتروني',
                          prefixIcon: const Icon(Icons.qr_code_2_rounded, color: AppColors.primary, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                    shadowColor: AppColors.orange.withValues(alpha: 0.3),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      StatusDialogs.showLoading(context);
                      final success = await viewModel.submitDataTwo({
                        'department': _selectedDepartment ?? '1',
                        'qualification': _selectedQualification ?? '1',
                        'status': _selectedStatus ?? '4',
                        'school': _schoolController.text.trim(),
                        'year': _yearController.text.trim(),
                        'total': _totalController.text.trim(),
                        'degree': _degreeController.text.trim(),
                        'rate': _rateController.text.trim(),
                        'seat_number': _seatNumberController.text.trim(),
                        'password_coordination': _passwordCoordinationController.text.trim(),
                        'code_coordination': _codeCoordinationController.text.trim(),
                      });
                      if (!context.mounted) return;
                      StatusDialogs.hide(context);

                      if (success) {
                        StatusDialogs.showSuccess(
                          context,
                          'تم تقديم طلب الالتحاق بنجاح! سيتم مراجعة بياناتك والتواصل معك.',
                          onComplete: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRoutes.signIn,
                              (route) => false,
                            );
                          },
                        );
                      } else {
                        StatusDialogs.showError(
                          context,
                          viewModel.errorMessage ?? 'فشل إرسال طلب الالتحاق',
                        );
                      }
                    }
                  },
                  child: Text(
                    langCode == 'en' ? 'Complete Application' : 'إرسال طلب الالتحاق النهائي',
                    style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
