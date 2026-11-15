import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
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
      backgroundColor: AppColors.bgColorLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                // Top Brand Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.mainC,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mainC.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.get('rayatxt', langCode),
                        style: AppTextStyles.cairoExtraBold(
                          fontSize: 24,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppStrings.get('portalOfRaya', langCode),
                        style: AppTextStyles.cairoBold(
                          fontSize: 14,
                          color: AppColors.hello,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Role Selector Chips
                Row(
                  children: [
                    _buildRoleChip(
                      context,
                      title: langCode == 'en' ? 'Student' : 'طالب',
                      role: SignInRole.student,
                      current: viewModel.selectedRole,
                    ),
                    const SizedBox(width: 8),
                    _buildRoleChip(
                      context,
                      title: langCode == 'en' ? 'Professor' : 'دكتور',
                      role: SignInRole.professor,
                      current: viewModel.selectedRole,
                    ),
                    const SizedBox(width: 8),
                    _buildRoleChip(
                      context,
                      title: langCode == 'en' ? 'Admin' : 'مشرف',
                      role: SignInRole.admin,
                      current: viewModel.selectedRole,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Inputs
                TextFormField(
                  controller: _userCodeController,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: AppStrings.get('usernametxt', langCode),
                    prefixIcon: const Icon(AppIcons.person, color: AppColors.mainC),
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
                  controller: _nationalIdController,
                  obscureText: true,
                  decoration: AppDecorations.inputDecoration(
                    context: context,
                    hintText: AppStrings.get('passwordtxt', langCode),
                    prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.mainC),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return AppStrings.get('invaild_S', langCode);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Terms and Conditions Link
                InkWell(
                  onTap: () => _showTermsDialog(context, langCode),
                  child: Text(
                    AppStrings.get('terms_conditions_clickable', langCode),
                    style: AppTextStyles.cairoBold(
                      fontSize: 13,
                      color: AppColors.mainC,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                // Sign In Button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      StatusDialogs.showLoading(context);
                      final success = await viewModel.login(
                        _userCodeController.text.trim(),
                        _nationalIdController.text.trim(),
                      );
                      StatusDialogs.hide(context);

                      if (success) {
                        if (mounted) {
                          StatusDialogs.showSuccess(
                            context,
                            AppStrings.get('login_success', langCode),
                            onComplete: () {
                              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                            },
                          );
                        }
                      } else {
                        if (mounted) {
                          StatusDialogs.showError(
                            context,
                            AppStrings.get(viewModel.errorMessage ?? 'login_failed', langCode),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainC,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    langCode == 'en' ? 'Sign In' : 'تسجيل الدخول',
                    style: AppTextStyles.cairoBold(fontSize: 16, color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 24),

                // Secondary Links (Visitors & Admission)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.guest);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.mainC),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          AppStrings.get('guest_portal', langCode),
                          style: AppTextStyles.cairoBold(
                            fontSize: 13,
                            color: AppColors.mainC,
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
                          disabledBackgroundColor: Colors.grey.shade400,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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

                // Contact WhatsApp Support
                TextButton.icon(
                  onPressed: () async {
                    final uri = Uri.parse('https://wa.me/201005595737');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(AppIcons.phone, color: AppColors.whatsApp, size: 20),
                  label: Text(
                    langCode == 'en' ? 'Support via WhatsApp' : 'تواصل معنا عبر واتساب',
                    style: AppTextStyles.cairoBold(
                      fontSize: 13,
                      color: AppColors.whatsApp,
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

  Widget _buildRoleChip(
    BuildContext context, {
    required String title,
    required SignInRole role,
    required SignInRole current,
  }) {
    final isSelected = role == current;
    return Expanded(
      child: InkWell(
        onTap: () => context.read<SignInViewModel>().setRole(role),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.mainC : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.mainC : Colors.grey.shade300,
            ),
          ),
          child: Text(
            title,
            style: AppTextStyles.cairoBold(
              fontSize: 13,
              color: isSelected ? AppColors.white : AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showTermsDialog(BuildContext context, String langCode) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppStrings.get('terms_conditions_clickable', langCode),
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.mainC),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Text(
            AppStrings.get('terms_conditions_all', langCode),
            style: AppTextStyles.cairoMedium(fontSize: 14, color: AppColors.dGray),
            textAlign: TextAlign.start,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.mainC),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              langCode == 'en' ? 'Agree' : 'موافق',
              style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
