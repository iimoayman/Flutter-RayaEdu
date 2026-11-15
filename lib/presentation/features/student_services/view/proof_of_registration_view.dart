import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../common_widgets/status_dialogs.dart';
import '../viewmodel/student_services_viewmodel.dart';

class ProofOfRegistrationView extends StatefulWidget {
  const ProofOfRegistrationView({Key? key}) : super(key: key);

  @override
  State<ProofOfRegistrationView> createState() => _ProofOfRegistrationViewState();
}

class _ProofOfRegistrationViewState extends State<ProofOfRegistrationView> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _destinationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StudentServicesViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.bgColorLight,
      appBar: AppBar(
        title: Text(
          AppStrings.get('POReg', langCode),
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.backArrow, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _destinationController,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: langCode == 'en' ? 'Addressed Destination (e.g. Ministry)' : 'الجهة الموجه إليها إثبات القيد',
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
                  controller: _notesController,
                  maxLines: 3,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: langCode == 'en' ? 'Notes (Optional)' : 'ملاحظات إضافية',
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainC,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      StatusDialogs.showLoading(context);
                      final success = await viewModel.submitService(
                        serviceType: '1',
                        addressed: _destinationController.text.trim(),
                        notes: _notesController.text.trim(),
                      );
                      StatusDialogs.hide(context);
                      if (success) {
                        StatusDialogs.showSuccess(
                          context,
                          AppStrings.get('sended', langCode),
                          onComplete: () => Navigator.of(context).pop(),
                        );
                      } else {
                        StatusDialogs.showError(context, 'Failed to submit request');
                      }
                    }
                  },
                  child: Text(
                    AppStrings.get('submit', langCode),
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
