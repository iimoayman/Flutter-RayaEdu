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
        body: const Center(child: Text('لم يتم اختيار اختبار')),
      );
    }

    return PopScope(
      canPop: viewModel.isAlreadySubmitted,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'لا يمكن الرجوع أثناء أداء الاختبار',
              textDirection: TextDirection.rtl,
            ),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.bgLight,
        appBar: AppBar(
          title: Text(
            exam.name,
            style: AppTextStyles.cairoBold(fontSize: 17, color: AppColors.white),
          ),
          automaticallyImplyLeading: viewModel.isAlreadySubmitted,
          leading: viewModel.isAlreadySubmitted
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Locked Banner if already submitted
                if (viewModel.isAlreadySubmitted) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.mintSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.mintBorder, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.lock_rounded, color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تم الإجابة وتسليم الامتحان مسبقاً',
                                style: AppTextStyles.cairoExtraBold(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'هذا الاختبار مغلق ومكتمل، ولا يمكن تعديل أو إعادة إرسال الإجابات.',
                                style: AppTextStyles.cairoMedium(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

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
                      padding: const EdgeInsets.all(18),
                      decoration: AppDecorations.cardDecoration(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'السؤال ${index + 1}',
                                  style: AppTextStyles.cairoBold(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  q.head,
                                  style: AppTextStyles.cairoBold(
                                    fontSize: 15,
                                    color: AppColors.textDark,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (q.a != null)
                            _buildOptionTile(
                              label: 'أ: ${q.a}',
                              isSelected: selectedAnswer == 'A',
                              isLocked: viewModel.isAlreadySubmitted,
                              onTap: () => viewModel.selectAnswer(q.pk, 'A'),
                            ),
                          if (q.b != null)
                            _buildOptionTile(
                              label: 'ب: ${q.b}',
                              isSelected: selectedAnswer == 'B',
                              isLocked: viewModel.isAlreadySubmitted,
                              onTap: () => viewModel.selectAnswer(q.pk, 'B'),
                            ),
                          if (q.c != null)
                            _buildOptionTile(
                              label: 'ج: ${q.c}',
                              isSelected: selectedAnswer == 'C',
                              isLocked: viewModel.isAlreadySubmitted,
                              onTap: () => viewModel.selectAnswer(q.pk, 'C'),
                            ),
                          if (q.d != null)
                            _buildOptionTile(
                              label: 'د: ${q.d}',
                              isSelected: selectedAnswer == 'D',
                              isLocked: viewModel.isAlreadySubmitted,
                              onTap: () => viewModel.selectAnswer(q.pk, 'D'),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                if (viewModel.isAlreadySubmitted) ...[
                  // Locked Exam Return Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                      shadowColor: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: Text(
                      'العودة إلى قائمة الاختبارات',
                      style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.white),
                    ),
                  ),
                ] else ...[
                  // Confirmation Container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.orangeLight,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.orangeBorder),
                    ),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          value: viewModel.confirmOne,
                          onChanged: (val) => viewModel.toggleConfirmOne(val ?? false),
                          title: Text(
                            langCode == 'en'
                                ? 'I have answered all questions carefully.'
                                : 'أقر بأنني قمت بالإجابة على جميع الأسئلة بعناية.',
                            style: AppTextStyles.cairoBold(fontSize: 13, color: AppColors.textDark),
                          ),
                          activeColor: AppColors.primary,
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        CheckboxListTile(
                          value: viewModel.confirmTwo,
                          onChanged: (val) => viewModel.toggleConfirmTwo(val ?? false),
                          title: Text(
                            langCode == 'en'
                                ? 'I understand I cannot retake this exam.'
                                : 'أعلم أنه لا يمكنني إعادة إرسال هذا الاختبار مرة أخرى.',
                            style: AppTextStyles.cairoBold(fontSize: 13, color: AppColors.textDark),
                          ),
                          activeColor: AppColors.primary,
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: AppColors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade500,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                      shadowColor: AppColors.orange.withValues(alpha: 0.3),
                    ),
                    onPressed: viewModel.canSubmit
                        ? () async {
                            StatusDialogs.showLoading(context);
                            final success = await viewModel.submitExam();
                            if (!context.mounted) return;
                            StatusDialogs.hide(context);

                            if (success) {
                              StatusDialogs.showSuccess(
                                context,
                                'تم إرسال إجابات الاختبار بنجاح',
                                onComplete: () {
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                              );
                            } else {
                              StatusDialogs.showError(
                                context,
                                'فشل إرسال إجابات الاختبار، يرجى المحاولة مرة أخرى',
                              );
                            }
                          }
                        : null,
                    child: Text(
                      langCode == 'en' ? 'Submit Exam' : 'إرسال الإجابات وتأكيد الاختبار',
                      style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.white),
                    ),
                  ),
                ],
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
    bool isLocked = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLocked ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.mintSurface : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.borderSubtle,
                width: isSelected ? 1.6 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: isSelected ? AppColors.primary : AppColors.textLight,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.cairoMedium(
                      fontSize: 14,
                      color: isSelected ? AppColors.primaryDark : AppColors.textDark,
                    ),
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
