import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../../core/utils/url_launcher_helper.dart';

class LocationView extends StatefulWidget {
  const LocationView({Key? key}) : super(key: key);

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  final Map<String, String> _locations = {
    'شؤون الطلاب': 'الدور الأرضي - مبنى أ',
    'الخزينة': 'الدور الأرضي - بجوار شؤون الطلاب',
    'مكتب العميدة': 'الدور الأول - مبنى الإدارة',
    'مدرج 1': 'الدور الثاني - مبنى المحاضرات',
    'مدرج 2': 'الدور الثاني - مبنى المحاضرات',
    'معمل الحاسب الآلي 1': 'الدور الثالث - قسم نظم المعلومات',
    'معمل الحاسب الآلي 2': 'الدور الثالث - قسم نظم المعلومات',
    'المكتبة المركزية': 'الدور الرابع - مبنى ب',
    'الكافتيريا': 'الفناء الرئيسي',
    'عيادة المعهد': 'الدور الأرضي - مبنى الخدمات',
  };

  String? _selectedPlace;
  String? _selectedInfo;

  String? _getFloorImage(String? info) {
    if (info == null) return null;
    if (info.contains('الأول')) return 'assets/images/floor_one.webp';
    if (info.contains('الثاني')) return 'assets/images/floor_two.webp';
    if (info.contains('الثالث')) return 'assets/images/floor_three.webp';
    if (info.contains('الرابع')) return 'assets/images/floor_four.webp';
    return 'assets/images/floor_one.webp';
  }

  Future<void> _openCampusMap() async {
    await UrlLauncherHelper.launchExternalUrl(
      context,
      'https://maps.google.com/?q=Raya+Higher+Institute',
      fallbackTitle: 'موقع المعهد على الخريطة',
    );
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(
          AppStrings.get('WhereIsIt', langCode),
          style: AppTextStyles.cairoBold(fontSize: 18, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.backArrow, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded, color: AppColors.white),
            tooltip: 'موقع المعهد على الخريطة',
            onPressed: _openCampusMap,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Selected Place Display
            if (_selectedPlace != null) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.all(20),
                decoration: AppDecorations.cardDecoration(
                  context,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.mintBorder, width: 1.2),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.mintSurface,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedPlace!,
                          style: AppTextStyles.cairoExtraBold(
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.orangeLight,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.orangeBorder),
                      ),
                      child: Text(
                        _selectedInfo!,
                        style: AppTextStyles.cairoBold(
                          fontSize: 13,
                          color: AppColors.orangeDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_getFloorImage(_selectedInfo) != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderSubtle),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.asset(
                            _getFloorImage(_selectedInfo)!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],

            // Locations Directory
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _locations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (ctx, index) {
                  final place = _locations.keys.elementAt(index);
                  final info = _locations[place]!;
                  final isSelected = _selectedPlace == place;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPlace = place;
                          _selectedInfo = info;
                        });
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(16),
                        decoration: AppDecorations.cardDecoration(
                          context,
                          borderRadius: BorderRadius.circular(18),
                          border: isSelected
                              ? Border.all(color: AppColors.primary, width: 1.5)
                              : null,
                          color: isSelected ? AppColors.mintSurface : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.white : AppColors.mintSurface,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.place_rounded,
                                color: isSelected ? AppColors.primary : AppColors.primaryLight,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    place,
                                    style: AppTextStyles.cairoBold(
                                      fontSize: 15,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    info,
                                    style: AppTextStyles.cairoRegular(
                                      fontSize: 13,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: isSelected ? AppColors.primary : AppColors.textLight,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
