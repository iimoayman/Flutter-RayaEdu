import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../viewmodel/guest_viewmodel.dart';

class CrewView extends StatelessWidget {
  const CrewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GuestViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.bgColorLight,
      appBar: AppBar(
        title: Text(
          AppStrings.get('faculty_crew', langCode),
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.backArrow, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: viewModel.crewList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (ctx, index) {
            final doctor = viewModel.crewList[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.cardDecoration(context),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.mainC.withValues(alpha: 0.12),
                    radius: 26,
                    child: const Icon(AppIcons.person, color: AppColors.mainC),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: AppTextStyles.cairoBold(
                            fontSize: 15,
                            color: AppColors.black,
                          ),
                        ),
                        if (doctor.department.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            doctor.department,
                            style: AppTextStyles.cairoMedium(
                              fontSize: 13,
                              color: AppColors.mainC,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (doctor.academicRank.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        doctor.academicRank,
                        style: AppTextStyles.cairoBold(
                          fontSize: 11,
                          color: AppColors.orange,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
