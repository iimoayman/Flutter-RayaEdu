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
        body: const Center(child: Text('No Program Selected')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgColorLight,
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
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: AppDecorations.cardDecoration(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.mainC.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(program.icon, size: 45, color: AppColors.mainC),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppStrings.get(program.titleKey, langCode),
                  style: AppTextStyles.cairoExtraBold(
                    fontSize: 20,
                    color: AppColors.mainC,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  AppStrings.get(program.detailsKey, langCode),
                  style: AppTextStyles.cairoMedium(
                    fontSize: 14,
                    color: AppColors.dGray,
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
