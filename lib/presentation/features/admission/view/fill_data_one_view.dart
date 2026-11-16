import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../common_widgets/status_dialogs.dart';
import '../../../navigation/app_routes.dart';
import '../viewmodel/admission_viewmodel.dart';

class FillDataOneView extends StatefulWidget {
  const FillDataOneView({Key? key}) : super(key: key);

  @override
  State<FillDataOneView> createState() => _FillDataOneViewState();
}

class _FillDataOneViewState extends State<FillDataOneView> {
  final _formKey = GlobalKey<FormState>();

  final _fatherNameController = TextEditingController();
  final _fatherWorkController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressCardController = TextEditingController();
  final _addressCurrentController = TextEditingController();
  final _issuingCardController = TextEditingController();
  final _addressBirthController = TextEditingController();
  final _birthDateController = TextEditingController();

  String? _selectedReligion;
  String? _selectedWorkType;
  String? _selectedGovBirth;
  String? _selectedGovCard;
  String? _selectedGovCurrent;

  final List<String> _workTypes = ['حكومي', 'قطاع خاص', 'أعمال حرة', 'معاش'];

  @override
  void dispose() {
    _fatherNameController.dispose();
    _fatherWorkController.dispose();
    _phoneController.dispose();
    _addressCardController.dispose();
    _addressCurrentController.dispose();
    _issuingCardController.dispose();
    _addressBirthController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdmissionViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final religions = viewModel.optionsData?.religions ?? [];
    final governorates = viewModel.optionsData?.governorates ?? [];

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(
          langCode == 'en' ? 'Personal Details (1/2)' : 'البيانات الشخصية (1/2)',
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
                    color: AppColors.mintSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.mintBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'المرحلة 1 من 2',
                          style: AppTextStyles.cairoBold(fontSize: 11, color: AppColors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'بيانات الأسرة والعنوان والميلاد',
                        style: AppTextStyles.cairoBold(fontSize: 13, color: AppColors.primary),
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
                      // Religion Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedReligion,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'الديانة',
                          prefixIcon: const Icon(Icons.bookmark_outline_rounded, color: AppColors.primary, size: 20),
                        ),
                        items: religions
                            .map((r) => DropdownMenuItem(
                                  value: r.pk.toString(),
                                  child: Text(r.name),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedReligion = val),
                        validator: (val) => val == null ? 'يرجى اختيار الديانة' : null,
                      ),
                      const SizedBox(height: 14),

                      // Father Name
                      TextFormField(
                        controller: _fatherNameController,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'اسم الوالد رباعياً',
                          prefixIcon: const Icon(AppIcons.person, color: AppColors.primary, size: 20),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'يرجى إدخال اسم الوالد'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      // Work Type Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedWorkType,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'نوع عمل الوالد',
                          prefixIcon: const Icon(Icons.work_outline_rounded, color: AppColors.primary, size: 20),
                        ),
                        items: _workTypes
                            .map((w) => DropdownMenuItem(
                                  value: w,
                                  child: Text(w),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedWorkType = val),
                      ),
                      const SizedBox(height: 14),

                      // Father Work
                      TextFormField(
                        controller: _fatherWorkController,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'وظيفة الوالد بالتفصيل',
                          prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.primary, size: 20),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Contact Phone
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'رقم هاتف إضافي للتواصل',
                          prefixIcon: const Icon(AppIcons.phone, color: AppColors.primary, size: 20),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Birth Date DatePicker
                      TextFormField(
                        controller: _birthDateController,
                        readOnly: true,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'تاريخ الميلاد (YYYY-MM-DD)',
                          prefixIcon: const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 20),
                        ),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2005, 1, 1),
                            firstDate: DateTime(1980),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            _birthDateController.text =
                                DateFormat('yyyy-MM-dd').format(picked);
                          }
                        },
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'يرجى تحديد تاريخ الميلاد'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      // Address Card
                      TextFormField(
                        controller: _addressCardController,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'العنوان المدون ببطاقة الرقم القومي',
                          prefixIcon: const Icon(Icons.home_outlined, color: AppColors.primary, size: 20),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Address Current
                      TextFormField(
                        controller: _addressCurrentController,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'العنوان الحالي بالتفصيل',
                          prefixIcon: const Icon(Icons.location_city_outlined, color: AppColors.primary, size: 20),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Issuing Card Place
                      TextFormField(
                        controller: _issuingCardController,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'جهة إصدار البطاقة',
                          prefixIcon: const Icon(Icons.apartment_rounded, color: AppColors.primary, size: 20),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Birth Governorate
                      DropdownButtonFormField<String>(
                        initialValue: _selectedGovBirth,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: 'محافظة الميلاد',
                          prefixIcon: const Icon(Icons.map_outlined, color: AppColors.primary, size: 20),
                        ),
                        items: governorates
                            .map((g) => DropdownMenuItem(
                                  value: g.pk.toString(),
                                  child: Text(g.name),
                                ))
                            .toList(),
                        onChanged: (val) => setState(() => _selectedGovBirth = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Next Step Button
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
                      final success = await viewModel.submitDataOne({
                        'religion': _selectedReligion ?? '1',
                        'father_name': _fatherNameController.text.trim(),
                        'type_work': _selectedWorkType ?? 'حكومي',
                        'father_work': _fatherWorkController.text.trim(),
                        'phone': _phoneController.text.trim(),
                        'address_card': _addressCardController.text.trim(),
                        'address_current': _addressCurrentController.text.trim(),
                        'issuing_card': _issuingCardController.text.trim(),
                        'governorate_birth': _selectedGovBirth ?? '1',
                        'governorate_card': _selectedGovCard ?? '1',
                        'governorate_current': _selectedGovCurrent ?? '1',
                        'address_birth': _addressBirthController.text.trim(),
                        'birth_date': _birthDateController.text.trim(),
                      });
                      if (!context.mounted) return;
                      StatusDialogs.hide(context);

                      if (success) {
                        Navigator.of(context).pushNamed(AppRoutes.fillDataTwo);
                      } else {
                        StatusDialogs.showError(
                          context,
                          viewModel.errorMessage ?? 'فشل حفظ البيانات الشخصية',
                        );
                      }
                    }
                  },
                  child: Text(
                    langCode == 'en' ? 'Next: Academic Data' : 'التالي: البيانات الدراسية',
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
