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

class NewCardView extends StatefulWidget {
  const NewCardView({Key? key}) : super(key: key);

  @override
  State<NewCardView> createState() => _NewCardViewState();
}

class _NewCardViewState extends State<NewCardView> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  @override
  void dispose() {
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
          AppStrings.get('newCard', langCode),
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
                Text(
                  langCode == 'en'
                      ? 'Request to issue a replacement student ID card.'
                      : 'طلب استخراج كارنيه طالب بدل فاقد.',
                  style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.mainC),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: langCode == 'en' ? 'Reason / Notes' : 'سبب الطلب أو ملاحظاتك',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return AppStrings.get('invaild_F', langCode);
                    }
                    return null;
                  },
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
                        serviceType: '4',
                        addressed: 'null',
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
