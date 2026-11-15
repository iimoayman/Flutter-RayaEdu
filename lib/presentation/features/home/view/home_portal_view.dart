import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../common_widgets/custom_drawer.dart';
import '../../../navigation/app_routes.dart';
import '../../edu_portal/view/edu_portal_tab_view.dart';
import '../../edu_portal/view/online_sessions_tab_view.dart';
import '../viewmodel/home_viewmodel.dart';
import '../viewmodel/notifications_viewmodel.dart';

class HomePortalView extends StatefulWidget {
  const HomePortalView({Key? key}) : super(key: key);

  @override
  State<HomePortalView> createState() => _HomePortalViewState();
}

class _HomePortalViewState extends State<HomePortalView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeVm = context.watch<HomeViewModel>();
    final notifVm = context.watch<NotificationsViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final student = homeVm.studentData;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgColorLight,
      drawer: const CustomDrawerWidget(activeRoute: AppRoutes.home),
      appBar: AppBar(
        backgroundColor: AppColors.mainC,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(AppIcons.drawer, color: AppColors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          // Notification with badge
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(AppIcons.notification, color: AppColors.white),
                onPressed: () {
                  notifVm.markAllRead();
                  Navigator.of(context).pushNamed(AppRoutes.notifications);
                },
              ),
              if (notifVm.unreadCount > 0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${notifVm.unreadCount}',
                      style: AppTextStyles.cairoBold(
                        fontSize: 9,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),

          // Digital ID profile avatar
          InkWell(
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.digitalId),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: student != null && student.photoUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: 'https://student.rayaedu.org${student.photoUrl}',
                        width: 38,
                        height: 38,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const CircleAvatar(
                          radius: 19,
                          backgroundColor: Colors.white24,
                          child: Icon(AppIcons.person, color: Colors.white, size: 20),
                        ),
                        errorWidget: (_, __, ___) => const CircleAvatar(
                          radius: 19,
                          backgroundColor: Colors.white24,
                          child: Icon(AppIcons.person, color: Colors.white, size: 20),
                        ),
                      )
                    : const CircleAvatar(
                        radius: 19,
                        backgroundColor: Colors.white24,
                        child: Icon(AppIcons.person, color: Colors.white, size: 20),
                      ),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.orange,
          indicatorWeight: 3.5,
          labelColor: AppColors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.white),
          tabs: [
            Tab(text: AppStrings.get('tab_platform', langCode)),
            Tab(text: AppStrings.get('tab_e_advisor', langCode)),
            Tab(text: AppStrings.get('OnlineSessionsTxt', langCode)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Platform / EduPortal
          const EduPortalTabView(),

          // Tab 2: Academic Advisor
          _buildAcademicAdvisorTab(context, homeVm, langCode),

          // Tab 3: Online Sessions
          const OnlineSessionsTabView(),
        ],
      ),
    );
  }

  Widget _buildAcademicAdvisorTab(
    BuildContext context,
    HomeViewModel homeVm,
    String langCode,
  ) {
    final student = homeVm.studentData;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Advisor Info Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: AppDecorations.cardDecoration(context),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.mainC.withValues(alpha: 0.12),
                  radius: 36,
                  child: const Icon(Icons.support_agent_rounded,
                      color: AppColors.mainC, size: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  student?.guideName ?? 'المرشد الأكاديمي',
                  style: AppTextStyles.cairoExtraBold(
                    fontSize: 17,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  langCode == 'en' ? 'Academic Advisor' : 'المرشد الأكاديمي المخصص لك',
                  style: AppTextStyles.cairoMedium(
                    fontSize: 13,
                    color: AppColors.mainC,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.whatsApp,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final whatsappUrl = student?.whatsapp;
                    if (whatsappUrl != null && whatsappUrl.isNotEmpty) {
                      _launchUrl(whatsappUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppStrings.get('NoAcademicAdvisor', langCode),
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(AppIcons.chat, color: AppColors.white),
                  label: Text(
                    langCode == 'en' ? 'Contact via WhatsApp' : 'تواصل مع المرشد',
                    style: AppTextStyles.cairoBold(
                      fontSize: 14,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tech Support Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppDecorations.cardDecoration(context),
            child: Row(
              children: [
                const Icon(Icons.headset_mic_rounded, color: AppColors.orange, size: 30),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        langCode == 'en' ? 'Technical Support' : 'الدعم الفني',
                        style: AppTextStyles.cairoBold(
                          fontSize: 15,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        langCode == 'en' ? 'Direct WhatsApp help' : 'مساعدة فورية عبر واتساب',
                        style: AppTextStyles.cairoMedium(
                          fontSize: 12,
                          color: AppColors.lightGray,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(AppIcons.forwardArrow, color: AppColors.mainC),
                  onPressed: () => _launchUrl('https://wa.me/201005595737'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ICT Channel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppDecorations.cardDecoration(context),
            child: Row(
              children: [
                const Icon(Icons.campaign_rounded, color: AppColors.mainC, size: 30),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        langCode == 'en' ? 'ICT News Channel' : 'قناة تكنولوجيا المعلومات',
                        style: AppTextStyles.cairoBold(
                          fontSize: 15,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        langCode == 'en' ? 'Institute official updates' : 'تحديثات وإعلانات المعهد الرسمية',
                        style: AppTextStyles.cairoMedium(
                          fontSize: 12,
                          color: AppColors.lightGray,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(AppIcons.forwardArrow, color: AppColors.mainC),
                  onPressed: () =>
                      _launchUrl('https://whatsapp.com/channel/0029Vb7SEl8It5s0XFhLxp1v'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
