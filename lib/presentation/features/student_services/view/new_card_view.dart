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
      backgroundColor: AppColors.bgLight,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.orangeLight,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.orangeBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(AppIcons.newCard, color: AppColors.orange, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          langCode == 'en'
                              ? 'Request to issue a replacement student ID card.'
                              : 'طلب استخراج كارنيه طالب (بدل فاقد أو تالف).',
                          style: AppTextStyles.cairoBold(fontSize: 13.5, color: AppColors.orangeDark),
                        ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'سبب الطلب أو تفاصيل الفقد',
                        style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.textDark),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 4,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: langCode == 'en' ? 'Reason / Notes' : 'اكتب سبب الطلب أو أي ملاحظات ترغب في توضيحها...',
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return AppStrings.get('invaild_F', langCode);
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                    shadowColor: AppColors.orange.withValues(alpha: 0.3),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      StatusDialogs.showLoading(context);
                      final success = await viewModel.submitService(
                        serviceType: '4',
                        addressed: 'null',
                        notes: _notesController.text.trim(),
                      );
                      if (!context.mounted) return;
                      StatusDialogs.hide(context);
                      if (success) {
                        StatusDialogs.showSuccess(
                          context,
                          AppStrings.get('sended', langCode),
                          onComplete: () => Navigator.of(context).pop(),
                        );
                      } else {
                        StatusDialogs.showError(context, 'فشل إرسال الطلب، يرجى المحاولة لاحقاً');
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
