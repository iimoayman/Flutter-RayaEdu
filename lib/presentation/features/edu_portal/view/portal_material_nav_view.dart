import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../common_widgets/loading_indicator.dart';
import '../../../common_widgets/status_dialogs.dart';
import '../../../navigation/app_routes.dart';
import '../viewmodel/edu_portal_viewmodel.dart';
import '../viewmodel/exam_viewmodel.dart';

class PortalMaterialNavView extends StatefulWidget {
  const PortalMaterialNavView({Key? key}) : super(key: key);

  @override
  State<PortalMaterialNavView> createState() => _PortalMaterialNavViewState();
}

class _PortalMaterialNavViewState extends State<PortalMaterialNavView>
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
    final viewModel = context.watch<EduPortalViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final portalData = viewModel.mainPortal;
    final chapterDetails = portalData?.chapterData;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgColorLight,
      drawer: _buildChaptersDrawer(context, viewModel, langCode),
      appBar: AppBar(
        title: Text(
          viewModel.currentMaterialName ?? 'المقرر الدراسي',
          style: AppTextStyles.cairoBold(fontSize: 17, color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.drawer, color: AppColors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.backArrow, color: AppColors.white),
            onPressed: () => Navigator.of(context).pop(),
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
            Tab(text: AppStrings.get('tab_lectures_and_resources', langCode)),
            Tab(text: AppStrings.get('menuThree', langCode)),
            Tab(text: AppStrings.get('tab_complete_unit', langCode)),
          ],
        ),
      ),
      body: viewModel.isLoading
          ? const LoadingIndicatorWidget()
          : TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Lectures & Resources
                _buildResourcesTab(context, chapterDetails?.resources ?? []),

                // Tab 2: Exams
                _buildExamsTab(
                  context,
                  chapterDetails?.examChapters ?? [],
                  chapterDetails?.pk ?? 0,
                  langCode,
                ),

                // Tab 3: End Unit
                _buildEndUnitTab(context, viewModel, langCode),
              ],
            ),
    );
  }

  Widget _buildChaptersDrawer(
    BuildContext context,
    EduPortalViewModel viewModel,
    String langCode,
  ) {
    final chapters = viewModel.mainPortal?.chapters ?? [];

    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                langCode == 'en' ? 'Course Chapters' : 'فصول المقرر',
                style: AppTextStyles.cairoExtraBold(
                  fontSize: 18,
                  color: AppColors.mainC,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.separated(
                itemCount: chapters.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, index) {
                  final chapter = chapters[index];
                  final isSelected = viewModel.selectedChapterPk == chapter.pk;

                  return ListTile(
                    tileColor: isSelected
                        ? AppColors.mainC.withValues(alpha: 0.08)
                        : Colors.transparent,
                    leading: Icon(
                      chapter.complete
                          ? AppIcons.check
                          : Icons.radio_button_unchecked_rounded,
                      color: chapter.complete ? AppColors.mainC : Colors.grey,
                    ),
                    title: Text(
                      chapter.name,
                      style: AppTextStyles.cairoBold(
                        fontSize: 14,
                        color: isSelected ? AppColors.mainC : AppColors.black,
                      ),
                    ),
                    onTap: () {
                      viewModel.selectChapter(chapter.pk);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcesTab(BuildContext context, List<dynamic> resources) {
    if (resources.isEmpty) {
      return const Center(child: Text('لا توجد مصادر متاحة لهذا الفصل'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: resources.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, index) {
        final resource = resources[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: AppDecorations.cardDecoration(context),
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf_rounded, color: AppColors.red, size: 30),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  resource.name,
                  style: AppTextStyles.cairoBold(fontSize: 14, color: AppColors.black),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.download_rounded, color: AppColors.mainC),
                onPressed: () async {
                  final uri = Uri.parse(resource.url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExamsTab(
    BuildContext context,
    List<dynamic> exams,
    int chapterPk,
    String langCode,
  ) {
    if (exams.isEmpty) {
      return const Center(child: Text('لا توجد اختبارات متاحة'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: exams.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, index) {
        final exam = exams[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.cardDecoration(context),
          child: Row(
            children: [
              const Icon(AppIcons.exam, color: AppColors.orange, size: 32),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.name,
                      style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.black),
                    ),
                    Text(
                      '${exam.questions.length} أسئلة',
                      style: AppTextStyles.cairoMedium(fontSize: 12, color: AppColors.lightGray),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.mainC),
                onPressed: () {
                  context.read<ExamViewModel>().setExam(exam, chapterPk);
                  Navigator.of(context).pushNamed(AppRoutes.examController);
                },
                child: Text(
                  langCode == 'en' ? 'Start' : 'بدء',
                  style: AppTextStyles.cairoBold(fontSize: 13, color: AppColors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEndUnitTab(
    BuildContext context,
    EduPortalViewModel viewModel,
    String langCode,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(AppIcons.check, size: 70, color: AppColors.mainC),
            const SizedBox(height: 20),
            Text(
              langCode == 'en'
                  ? 'Have you completed all resources of this unit?'
                  : 'هل أتممت دراسة كافة مصادر هذا الفصل؟',
              style: AppTextStyles.cairoBold(fontSize: 16, color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainC,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                StatusDialogs.showLoading(context);
                final success = await viewModel.completeUnit();
                StatusDialogs.hide(context);
                if (success) {
                  StatusDialogs.showSuccess(
                    context,
                    langCode == 'en'
                        ? 'Unit completed successfully!'
                        : 'تم إنهاء الفصل بنجاح!',
                  );
                } else {
                  StatusDialogs.showError(
                    context,
                    langCode == 'en' ? 'Failed to complete unit' : 'فشل تأكيد إنهاء الفصل',
                  );
                }
              },
              child: Text(
                langCode == 'en' ? 'Confirm Completion' : 'تأكيد إتمام الفصل',
                style: AppTextStyles.cairoBold(fontSize: 15, color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
