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
      backgroundColor: AppColors.bgColorLight,
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
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Department Selection
                DropdownButtonFormField<String>(
                  initialValue: _selectedDepartment,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: 'القسم المراد الالتحاق به',
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

                // School / Institute
                TextFormField(
                  controller: _schoolController,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: 'المدرسة / المعهد المتخرج منه',
                  ),
                ),
                const SizedBox(height: 14),

                // Qualification Year
                TextFormField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: 'سنة الحصول على المؤهل',
                  ),
                ),
                const SizedBox(height: 14),

                // Total and Degree
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _totalController,
                        keyboardType: TextInputType.number,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'المجموع الكلي',
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'المجموع الكلي مطلوب'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _degreeController,
                        keyboardType: TextInputType.number,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'مجموع الطالب',
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'مجموع الطالب مطلوب'
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Rate Percentage (Auto Calculated)
                TextFormField(
                  controller: _rateController,
                  readOnly: true,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: 'النسبة المئوية (%)',
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
                  ),
                ),
                const SizedBox(height: 14),

                // Coordination Status
                DropdownButtonFormField<String>(
                  initialValue: _selectedStatus,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: 'حالة القيد',
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

                // Coordination Code
                TextFormField(
                  controller: _codeCoordinationController,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: 'كود التنسيق الإلكتروني',
                  ),
                ),
                const SizedBox(height: 28),

                // Submit All Application Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainC,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      StatusDialogs.showLoading(context);
                      final success = await viewModel.submitDataTwo({
                        'department': _selectedDepartment ?? '1',
                        'qualification': _selectedQualification ?? '1',
                        'qualification_year': _yearController.text.trim(),
                        'school': _schoolController.text.trim(),
                        'total_degree': _totalController.text.trim(),
                        'degree': _degreeController.text.trim(),
                        'rate_degree': _rateController.text.replaceAll('%', '').trim(),
                        'seat_number': _seatNumberController.text.trim(),
                        'password_coordination': _passwordCoordinationController.text.trim(),
                        'status': _selectedStatus ?? '4',
                        'code_coordination': _codeCoordinationController.text.trim(),
                        'accept_date': '',
                        'accept_code': '',
                        'transform_place': '',
                      });
                      StatusDialogs.hide(context);

                      if (success) {
                        StatusDialogs.showSuccess(
                          context,
                          langCode == 'en'
                              ? 'Admission application submitted successfully!'
                              : 'تم تقديم طلب الالتحاق بنجاح!',
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
                    langCode == 'en'
                        ? 'Submit Admission Form'
                        : 'إرسال طلب التقديم النهائي',
                    style: AppTextStyles.cairoBold(
                        fontSize: 15, color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
