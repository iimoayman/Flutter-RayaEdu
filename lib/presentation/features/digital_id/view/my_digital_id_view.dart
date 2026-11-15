import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: AppColors.bgColorLight,
      appBar: AppBar(
        title: Text(
          langCode == 'en' ? 'Digital ID' : 'الهوية الرقمية',
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
              onRefresh: () => viewModel.loadStudentData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Digital ID Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.mainC, AppColors.darkGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mainC.withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: student != null && student.photoUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: 'https://student.rayaedu.org${student.photoUrl}',
                                        width: 75,
                                        height: 75,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Container(
                                          width: 75,
                                          height: 75,
                                          color: Colors.white24,
                                          child: const Icon(AppIcons.person, color: Colors.white),
                                        ),
                                        errorWidget: (_, __, ___) => Container(
                                          width: 75,
                                          height: 75,
                                          color: Colors.white24,
                                          child: const Icon(AppIcons.person, color: Colors.white),
                                        ),
                                      )
                                    : Container(
                                        width: 75,
                                        height: 75,
                                        color: Colors.white24,
                                        child: const Icon(AppIcons.person, color: Colors.white, size: 40),
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
                                        fontSize: 17,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${AppStrings.get('stu_id', langCode)}: ${student?.code ?? '---'}',
                                      style: AppTextStyles.cairoBold(
                                        fontSize: 13,
                                        color: AppColors.hello,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      student?.academicYear ?? '2025/2026',
                                      style: AppTextStyles.cairoMedium(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: Colors.white24, thickness: 1),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _mapDepartment(student?.department, langCode),
                                style: AppTextStyles.cairoBold(fontSize: 13, color: AppColors.white),
                              ),
                              Text(
                                _mapLevel(student?.level, langCode),
                                style: AppTextStyles.cairoBold(fontSize: 13, color: AppColors.orange),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          // QR Code Container
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
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
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                            decoration: AppDecorations.cardDecoration(context),
                            child: Column(
                              children: [
                                Text(
                                  'CGPA',
                                  style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.lightGray),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  student?.cgpa?.toStringAsFixed(2) ?? '--',
                                  style: AppTextStyles.cairoExtraBold(fontSize: 22, color: AppColors.mainC),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                            decoration: AppDecorations.cardDecoration(context),
                            child: Column(
                              children: [
                                Text(
                                  langCode == 'en' ? 'Credit Hours' : 'الساعات المسجلة',
                                  style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.lightGray),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  student?.hours?.toString() ?? '--',
                                  style: AppTextStyles.cairoExtraBold(fontSize: 22, color: AppColors.orange),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Shake Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.mainC.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.mainC.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.vibration_rounded, color: AppColors.mainC, size: 30),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              langCode == 'en'
                                  ? 'Shake your phone to report any problem or bug directly!'
                                  : 'قم بهز هاتفك للإبلاغ الفوري عن أي مشكلة أو استفسار!',
                              style: AppTextStyles.cairoMedium(fontSize: 13, color: AppColors.mainC),
                            ),
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
    final controller = TextEditingController();
    final langCode = context.read<LocaleProvider>().locale.languageCode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.get('shake_report_title', langCode),
              style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: AppStrings.get('shake_report_hint', langCode),
                filled: true,
                fillColor: AppColors.bgColorLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainC,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  Navigator.of(ctx).pop();
                  StatusDialogs.showLoading(context);
                  final success = await context.read<DigitalIdViewModel>().sendProblemReport(text);
                  StatusDialogs.hide(context);
                  if (success) {
                    StatusDialogs.showSuccess(context, AppStrings.get('sended', langCode));
                  } else {
                    StatusDialogs.showError(context, 'Failed to send problem');
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
      ),
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
