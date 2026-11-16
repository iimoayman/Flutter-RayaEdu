import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../common_widgets/loading_indicator.dart';
import '../../../common_widgets/status_dialogs.dart';
import '../viewmodel/digital_id_viewmodel.dart';

class MyDigitalIdView extends StatefulWidget {
  const MyDigitalIdView({Key? key}) : super(key: key);

  @override
  State<MyDigitalIdView> createState() => _MyDigitalIdViewState();
}

class _MyDigitalIdViewState extends State<MyDigitalIdView> {
  @override
  void initState() {
    super.initState();
    final vm = context.read<DigitalIdViewModel>();
    vm.onShakeDetected = () => _showShakeDialog(context);
    vm.startSensors();
  }

  @override
  void dispose() {
    context.read<DigitalIdViewModel>().stopSensors();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DigitalIdViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final student = viewModel.studentData;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        title: Text(
          langCode == 'en' ? 'Digital ID' : 'الهوية الرقمية للدارس',
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.backArrow, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: viewModel.isLoading
          ? const LoadingIndicatorWidget()
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => viewModel.loadStudentData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Column(
                  children: [
                    // Digital ID Card
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: AppColors.headerGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Card Header: Institute Info & Year
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      'assets/images/logo_raster.webp',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppStrings.get('rayatxt', langCode),
                                    style: AppTextStyles.cairoBold(
                                      fontSize: 14,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  student?.academicYear ?? '2025/2026',
                                  style: AppTextStyles.cairoMedium(
                                    fontSize: 11,
                                    color: AppColors.mintSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // Student Photo & Info
                          Row(
                            children: [
                              Container(
                                width: 78,
                                height: 78,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.orange, width: 2.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: student != null && student.photoUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: 'https://student.rayaedu.org${student.photoUrl}',
                                          fit: BoxFit.cover,
                                          placeholder: (_, __) => Image.asset(
                                            'assets/images/profile.webp',
                                            fit: BoxFit.cover,
                                          ),
                                          errorWidget: (_, __, ___) => Image.asset(
                                            'assets/images/profile.webp',
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Image.asset(
                                          'assets/images/profile.webp',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student?.name ?? 'اسم الطالب',
                                      style: AppTextStyles.cairoExtraBold(
                                        fontSize: 16,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${AppStrings.get('stu_id', langCode)}: ${student?.code ?? 'غير متوفر'}',
                                        style: AppTextStyles.cairoBold(
                                          fontSize: 12,
                                          color: AppColors.mintSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Divider(
                            color: Colors.white.withValues(alpha: 0.18),
                            thickness: 1,
                            height: 1,
                          ),
                          const SizedBox(height: 14),

                          // Department & Level Badges
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _mapDepartment(student?.department, langCode),
                                  style: AppTextStyles.cairoBold(fontSize: 12, color: AppColors.white),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.orange.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.orange.withValues(alpha: 0.6),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _mapLevel(student?.level, langCode),
                                  style: AppTextStyles.cairoBold(fontSize: 12, color: AppColors.orangeLight),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // QR Code Container
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: QrImageView(
                              data: student?.code?.toString() ?? 'RAYA_EDU_STUDENT',
                              version: QrVersions.auto,
                              size: 110.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Academic Stats (GPA & Registered Hours)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                            decoration: AppDecorations.cardDecoration(context),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppColors.mintSurface,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.analytics_rounded,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  langCode == 'en' ? 'CGPA' : 'المعدل التراكمي',
                                  style: AppTextStyles.cairoBold(fontSize: 13, color: AppColors.textMuted),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  student?.cgpa?.toStringAsFixed(2) ?? 'غير متوفر',
                                  style: AppTextStyles.cairoExtraBold(fontSize: 22, color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                            decoration: AppDecorations.cardDecoration(context),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppColors.orangeLight,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.schedule_rounded,
                                    color: AppColors.orange,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  langCode == 'en' ? 'Credit Hours' : 'الساعات المسجلة',
                                  style: AppTextStyles.cairoBold(fontSize: 13, color: AppColors.textMuted),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  student?.hours?.toString() ?? 'غير متوفر',
                                  style: AppTextStyles.cairoExtraBold(fontSize: 22, color: AppColors.orange),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Shake Phone Feedback
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Column(
                        children: [
                          Lottie.asset(
                            'assets/lottie/shake.json',
                            width: 110,
                            height: 110,
                            fit: BoxFit.contain,
                            repeat: true,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppStrings.get('shakePhone', langCode),
                            style: AppTextStyles.cairoBold(
                              fontSize: 14,
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showShakeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => _ShakeReportBottomSheet(parentContext: context),
    );
  }

  String _mapDepartment(String? dept, String langCode) {
    switch (dept) {
      case '1':
        return AppStrings.get('bisName', langCode);
      case '2':
        return AppStrings.get('ACCname', langCode);
      case '3':
        return AppStrings.get('TradeName', langCode);
      default:
        return AppStrings.get('bisName', langCode);
    }
  }

  String _mapLevel(String? lvl, String langCode) {
    final isEn = langCode == 'en';
    switch (lvl) {
      case '1':
        return isEn ? 'Level 1' : 'الفرقة الأولى';
      case '2':
        return isEn ? 'Level 2' : 'الفرقة الثانية';
      case '3':
        return isEn ? 'Level 3' : 'الفرقة الثالثة';
      case '4':
        return isEn ? 'Level 4' : 'الفرقة الرابعة';
      default:
        return isEn ? 'Level 1' : 'الفرقة الأولى';
    }
  }
}

class _ShakeReportBottomSheet extends StatefulWidget {
  final BuildContext parentContext;
  const _ShakeReportBottomSheet({required this.parentContext});

  @override
  State<_ShakeReportBottomSheet> createState() => _ShakeReportBottomSheetState();
}

class _ShakeReportBottomSheetState extends State<_ShakeReportBottomSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    return Container(
      decoration: AppDecorations.roundedTopContainer(context, radius: 28),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            AppStrings.get('shake_report_title', langCode),
            style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.textDark),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: AppDecorations.inputDecoration(
              context: context,
              hintText: AppStrings.get('shake_report_hint', langCode),
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            onPressed: () async {
              final text = _controller.text.trim();
              if (text.isNotEmpty) {
                final parentCtx = widget.parentContext;
                Navigator.of(context).pop();
                if (!parentCtx.mounted) return;
                StatusDialogs.showLoading(parentCtx);
                final success = await parentCtx
                    .read<DigitalIdViewModel>()
                    .sendProblemReport(text);
                if (!parentCtx.mounted) return;
                StatusDialogs.hide(parentCtx);
                if (success) {
                  StatusDialogs.showSuccess(
                    parentCtx,
                    AppStrings.get('sended', langCode),
                  );
                } else {
                  StatusDialogs.showError(parentCtx, 'فشل إرسال البلاغ');
                }
              }
            },
            child: Text(
              AppStrings.get('shake_send', langCode),
              style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
