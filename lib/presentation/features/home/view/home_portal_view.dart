import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../common_widgets/custom_drawer.dart';
import '../../../navigation/app_routes.dart';
import '../../edu_portal/view/edu_portal_tab_view.dart';
import '../viewmodel/home_viewmodel.dart';
import '../viewmodel/notifications_viewmodel.dart';

class HomePortalView extends StatefulWidget {
  const HomePortalView({super.key});

  @override
  State<HomePortalView> createState() => _HomePortalViewState();
}

class _HomePortalViewState extends State<HomePortalView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openMenu(BuildContext context) {
    if (_scaffoldKey.currentState?.hasDrawer ?? false) {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeVm = context.watch<HomeViewModel>();
    final notifVm = context.watch<NotificationsViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final student = homeVm.studentData;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgLight,
      drawer: const CustomDrawerWidget(activeRoute: AppRoutes.home),
      appBar: AppBar(
        toolbarHeight: 70.0,
        backgroundColor: AppColors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        actions: const <Widget>[], // Prevents Flutter from auto-inserting any menu button on the left
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        titleSpacing: 0,
        title: SizedBox(
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                // 1. الصورة الشخصية أقصى الشمال
                Tooltip(
                  message: langCode == 'en' ? 'Digital ID' : 'الهوية الرقمية',
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.digitalId),
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.orange, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: student != null && student.photoUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: 'https://student.rayaedu.org${student.photoUrl}',
                                width: 38,
                                height: 38,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Image.asset(
                                  'assets/images/profile.webp',
                                  width: 38,
                                  height: 38,
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (_, __, ___) => Image.asset(
                                  'assets/images/profile.webp',
                                  width: 38,
                                  height: 38,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                'assets/images/profile.webp',
                                width: 38,
                                height: 38,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // 2. الإشعارات بين الصورة الشخصية والكلمة
                Tooltip(
                  message: langCode == 'en' ? 'Notifications' : 'الإشعارات',
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(AppIcons.notification, color: AppColors.white, size: 24),
                        onPressed: () {
                          notifVm.markAllRead();
                          Navigator.of(context).pushNamed(AppRoutes.notifications);
                        },
                      ),
                      if (notifVm.unreadCount > 0)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 1.5),
                            ),
                            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                            child: Center(
                              child: Text(
                                '${notifVm.unreadCount}',
                                style: AppTextStyles.cairoBold(
                                  fontSize: 9,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // 3. الكلمة في النص
                Expanded(
                  child: Center(
                    child: Text(
                      AppStrings.get('portalOfRaya', langCode),
                      style: AppTextStyles.cairoExtraBold(
                        fontSize: 17,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: langCode == 'en' ? TextDirection.ltr : TextDirection.rtl,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                // 4. list icon يمين
                Tooltip(
                  message: langCode == 'en' ? 'Menu' : 'القائمة',
                  child: IconButton(
                    icon: const Icon(AppIcons.drawer, color: AppColors.white, size: 26),
                    onPressed: () => _openMenu(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: const EduPortalTabView(),
    );
  }
}
