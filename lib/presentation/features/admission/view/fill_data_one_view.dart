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
      backgroundColor: AppColors.bgColorLight,
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
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Religion Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedReligion,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: 'الديانة',
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
                    suffixIcon: const Icon(Icons.calendar_today_rounded,
                        color: AppColors.mainC),
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
                  ),
                ),
                const SizedBox(height: 14),

                // Address Current
                TextFormField(
                  controller: _addressCurrentController,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: 'العنوان الحالي بالتفصيل',
                  ),
                ),
                const SizedBox(height: 14),

                // Issuing Card Place
                TextFormField(
                  controller: _issuingCardController,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: 'جهة إصدار البطاقة',
                  ),
                ),
                const SizedBox(height: 14),

                // Birth Governorate
                DropdownButtonFormField<String>(
                  initialValue: _selectedGovBirth,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: 'محافظة الميلاد',
                  ),
                  items: governorates
                      .map((g) => DropdownMenuItem(
                            value: g.pk.toString(),
                            child: Text(g.name),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedGovBirth = val),
                ),
                const SizedBox(height: 24),

                // Next Step Button
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
