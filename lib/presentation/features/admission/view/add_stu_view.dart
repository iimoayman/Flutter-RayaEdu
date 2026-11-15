import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../common_widgets/status_dialogs.dart';
import '../../../navigation/app_routes.dart';
import '../viewmodel/admission_viewmodel.dart';

class AddStuView extends StatefulWidget {
  const AddStuView({Key? key}) : super(key: key);

  @override
  State<AddStuView> createState() => _AddStuViewState();
}

class _AddStuViewState extends State<AddStuView> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _idController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdmissionViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.bgColorLight,
      appBar: AppBar(
        title: Text(
          AppStrings.get('apply_admission', langCode),
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
                Text(
                  langCode == 'en'
                      ? 'Step 1: Identity & Phone Verification'
                      : 'الخطوة الأولى: التحقق من رقم الهاتف والرقم القومي',
                  style: AppTextStyles.cairoExtraBold(
                    fontSize: 16,
                    color: AppColors.mainC,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: AppStrings.get('stuPhNumber', langCode),
                    prefixIcon: const Icon(AppIcons.phone, color: AppColors.mainC),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return AppStrings.get('invaild_F', langCode);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: AppStrings.get('stu_national_id', langCode),
                    prefixIcon: const Icon(Icons.badge_rounded, color: AppColors.mainC),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return AppStrings.get('invaild_NID', langCode);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
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
                      final success = await viewModel.applyContinue(
                        phone: _phoneController.text.trim(),
                        identifier: _idController.text.trim(),
                      );
                      StatusDialogs.hide(context);

                      if (success) {
                        Navigator.of(context).pushNamed(AppRoutes.fillDataOne);
                      } else {
                        StatusDialogs.showError(
                          context,
                          viewModel.errorMessage ?? 'فشل التحقق',
                        );
                      }
                    }
                  },
                  child: Text(
                    langCode == 'en' ? 'Continue' : 'المتابعة للبيانات الشخصية',
                    style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
