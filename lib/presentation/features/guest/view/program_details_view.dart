import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../viewmodel/guest_viewmodel.dart';

class ProgramDetailsView extends StatelessWidget {
  const ProgramDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GuestViewModel>();
    final program = viewModel.selectedProgram;
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    if (program == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('لم يتم اختيار برنامج دراسي')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(
          AppStrings.get(program.titleKey, langCode),
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
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.cardDecoration(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderSubtle),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Image.asset(
                      program.detailImageAsset,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppStrings.get(program.titleKey, langCode),
                  style: AppTextStyles.cairoExtraBold(
                    fontSize: 20,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.borderSubtle, height: 1),
                const SizedBox(height: 16),
                Text(
                  AppStrings.get(program.detailsKey, langCode),
                  style: AppTextStyles.cairoMedium(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.7,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
