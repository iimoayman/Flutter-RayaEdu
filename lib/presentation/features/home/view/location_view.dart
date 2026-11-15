import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final langCode = context.watch<LocaleProvider>().locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.bgColorLight,
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
            onPressed: () => _openCampusMap(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Selected Place Display
            if (_selectedPlace != null) ...[
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.mainC,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mainC.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(AppIcons.location, color: AppColors.orange, size: 36),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedPlace!,
                            style: AppTextStyles.cairoBold(
                              fontSize: 16,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            _selectedInfo!,
                            style: AppTextStyles.cairoMedium(
                              fontSize: 14,
                              color: AppColors.hello,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Locations Directory
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _locations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (ctx, index) {
                  final place = _locations.keys.elementAt(index);
                  final info = _locations[place]!;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPlace = place;
                        _selectedInfo = info;
                      });
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppDecorations.cardDecoration(context),
                      child: Row(
                        children: [
                          const Icon(Icons.place_outlined,
                              color: AppColors.mainC, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              place,
                              style: AppTextStyles.cairoBold(
                                fontSize: 14,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          const Icon(AppIcons.forwardArrow,
                              color: AppColors.lightGray, size: 16),
                        ],
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

  void _openCampusMap() async {
    const mapUrl =
        'https://www.google.com/maps/d/u/0/edit?mid=1CBRdb7CbqvJQhWTLirS_pxB0qBkj9n8&usp=sharing';
    final uri = Uri.parse(mapUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
