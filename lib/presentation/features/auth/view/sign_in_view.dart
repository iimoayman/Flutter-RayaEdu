import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../../../common_widgets/status_dialogs.dart';
import '../../../navigation/app_routes.dart';
import '../viewmodel/sign_in_viewmodel.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();
  final _userCodeController = TextEditingController();
  final _nationalIdController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _userCodeController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignInViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),

                // Top Institutional Header Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    gradient: AppColors.headerGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDark.withValues(alpha: 0.25),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo_raster.webp',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.get('rayatxt', langCode),
                        style: AppTextStyles.cairoExtraBold(
                          fontSize: 22,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          AppStrings.get('portalOfRaya', langCode),
                          style: AppTextStyles.cairoMedium(
                            fontSize: 13,
                            color: AppColors.mintSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Form Container Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppDecorations.cardDecoration(
                    context,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Username / Student ID Input
                      TextFormField(
                        controller: _userCodeController,
                        keyboardType: TextInputType.text,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: AppStrings.get('usernametxt', langCode),
                          prefixIcon: const Icon(AppIcons.person, color: AppColors.primary, size: 22),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return AppStrings.get('invaild_F', langCode);
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // National ID / Password Input
                      TextFormField(
                        controller: _nationalIdController,
                        obscureText: _obscurePassword,
                        keyboardType: TextInputType.text,
                        decoration: AppDecorations.inputDecoration(
                          context: context,
                          hintText: AppStrings.get('passwordtxt', langCode),
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primary, size: 22),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return AppStrings.get('invaild_S', langCode);
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Terms and Conditions Link
                      Center(
                        child: InkWell(
                          onTap: () => _showTermsDialog(context, langCode),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text(
                              AppStrings.get('terms_conditions_clickable', langCode),
                              style: AppTextStyles.cairoBold(
                                fontSize: 13,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Sign In Button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            StatusDialogs.showLoading(context);
                            final success = await viewModel.login(
                              _userCodeController.text.trim(),
                              _nationalIdController.text.trim(),
                            );
                            if (!context.mounted) return;
                            StatusDialogs.hide(context);

                            if (success) {
                              StatusDialogs.showSuccess(
                                context,
                                AppStrings.get('login_success', langCode),
                                onComplete: () {
                                  Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                                },
                              );
                            } else {
                              StatusDialogs.showError(
                                context,
                                AppStrings.get(viewModel.errorMessage ?? 'login_failed', langCode),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                          shadowColor: AppColors.primary.withValues(alpha: 0.3),
                        ),
                        child: Text(
                          langCode == 'en' ? 'Sign In' : 'تسجيل الدخول',
                          style: AppTextStyles.cairoBold(fontSize: 16, color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Secondary Links (Visitors & Admission)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.guest);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary, width: 1.2),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          AppStrings.get('guest_portal', langCode),
                          style: AppTextStyles.cairoBold(
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: viewModel.isStudentApplied
                            ? null
                            : () {
                                Navigator.of(context).pushNamed(AppRoutes.addStu);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          foregroundColor: AppColors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                          shadowColor: AppColors.orange.withValues(alpha: 0.3),
                        ),
                        child: Text(
                          langCode == 'en' ? 'Apply Now' : 'التقديم للالتحاق',
                          style: AppTextStyles.cairoBold(
                            fontSize: 13,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // WhatsApp Support Link
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSubtle, width: 1),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => UrlLauncherHelper.launchExternalUrl(
                        context,
                        'https://wa.me/201005595737',
                        fallbackTitle: 'الدعم الفني عبر واتساب',
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8F5E9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                AppIcons.phone,
                                color: AppColors.whatsApp,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              langCode == 'en' ? 'Support via WhatsApp' : 'تواصل معنا عبر واتساب',
                              style: AppTextStyles.cairoBold(
                                fontSize: 13,
                                color: AppColors.whatsApp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTermsDialog(BuildContext context, String langCode) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          AppStrings.get('terms_conditions_clickable', langCode),
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 350),
          child: SingleChildScrollView(
            child: Text(
              AppStrings.get('terms_conditions_all', langCode),
              style: AppTextStyles.cairoMedium(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                langCode == 'en' ? 'Agree' : 'موافق',
                style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
