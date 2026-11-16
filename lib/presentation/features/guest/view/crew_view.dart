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
      backgroundColor: AppColors.bgLight,
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          itemCount: viewModel.crewList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, index) {
            final doctor = viewModel.crewList[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.cardDecoration(context),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.mintSurface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.mintBorder),
                    ),
                    child: const Center(
                      child: Icon(AppIcons.person, color: AppColors.primary, size: 26),
                    ),
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
                            color: AppColors.textDark,
                          ),
                        ),
                        if (doctor.department.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            doctor.department,
                            style: AppTextStyles.cairoMedium(
                              fontSize: 12.5,
                              color: AppColors.primary,
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
                        color: AppColors.orangeLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.orangeBorder),
                      ),
                      child: Text(
                        doctor.academicRank,
                        style: AppTextStyles.cairoBold(
                          fontSize: 11.5,
                          color: AppColors.orangeDark,
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
