import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../common_widgets/status_dialogs.dart';
import '../viewmodel/exam_viewmodel.dart';

class ExamControllerView extends StatelessWidget {
  const ExamControllerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExamViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final exam = viewModel.currentExam;

    if (exam == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('No Exam Selected')),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يمكن الرجوع أثناء أداء الاختبار')),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColorLight,
        appBar: AppBar(
          title: Text(
            exam.name,
            style: AppTextStyles.cairoBold(fontSize: 17, color: AppColors.white),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Questions List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exam.questions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (ctx, index) {
                    final q = exam.questions[index];
                    final selectedAnswer = viewModel.selectedAnswers[q.pk];

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppDecorations.cardDecoration(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ${q.head}',
                            style: AppTextStyles.cairoBold(
                              fontSize: 15,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (q.a != null)
                            _buildOptionTile(
                              label: 'A: ${q.a}',
                              isSelected: selectedAnswer == 'A',
                              onTap: () => viewModel.selectAnswer(q.pk, 'A'),
                            ),
                          if (q.b != null)
                            _buildOptionTile(
                              label: 'B: ${q.b}',
                              isSelected: selectedAnswer == 'B',
                              onTap: () => viewModel.selectAnswer(q.pk, 'B'),
                            ),
                          if (q.c != null)
                            _buildOptionTile(
                              label: 'C: ${q.c}',
                              isSelected: selectedAnswer == 'C',
                              onTap: () => viewModel.selectAnswer(q.pk, 'C'),
                            ),
                          if (q.d != null)
                            _buildOptionTile(
                              label: 'D: ${q.d}',
                              isSelected: selectedAnswer == 'D',
                              onTap: () => viewModel.selectAnswer(q.pk, 'D'),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Confirmation Checkboxes
                CheckboxListTile(
                  value: viewModel.confirmOne,
                  onChanged: (val) => viewModel.toggleConfirmOne(val ?? false),
                  title: Text(
                    langCode == 'en'
                        ? 'I have answered all questions carefully.'
                        : 'أقر بأنني قمت بالإجابة على جميع الأسئلة بعناية.',
                    style: AppTextStyles.cairoMedium(fontSize: 13, color: AppColors.black),
                  ),
                  activeColor: AppColors.mainC,
                ),
                CheckboxListTile(
                  value: viewModel.confirmTwo,
                  onChanged: (val) => viewModel.toggleConfirmTwo(val ?? false),
                  title: Text(
                    langCode == 'en'
                        ? 'I understand I cannot retake this exam.'
                        : 'أعلم أنه لا يمكنني إعادة إرسال هذا الاختبار مرة أخرى.',
                    style: AppTextStyles.cairoMedium(fontSize: 13, color: AppColors.black),
                  ),
                  activeColor: AppColors.mainC,
                ),
                const SizedBox(height: 16),

                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainC,
                    disabledBackgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: viewModel.canSubmit
                      ? () async {
                          StatusDialogs.showLoading(context);
                          final success = await viewModel.submitExam();
                          StatusDialogs.hide(context);
                          if (success) {
                            StatusDialogs.showSuccess(
                              context,
                              langCode == 'en'
                                  ? 'Answers submitted successfully!'
                                  : 'تم إرسال إجاباتك بنجاح!',
                              onComplete: () => Navigator.of(context).pop(),
                            );
                          } else {
                            StatusDialogs.showError(
                              context,
                              langCode == 'en'
                                  ? 'Submission failed. Please try again.'
                                  : 'فشل إرسال الإجابات، يرجى المحاولة ثانية',
                            );
                          }
                        }
                      : null,
                  child: Text(
                    langCode == 'en' ? 'Submit Exam' : 'إنهاء وإرسال الاختبار',
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

  Widget _buildOptionTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.mainC.withValues(alpha: 0.1) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.mainC : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.mainC : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.cairoMedium(
                    fontSize: 14,
                    color: isSelected ? AppColors.mainC : AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
