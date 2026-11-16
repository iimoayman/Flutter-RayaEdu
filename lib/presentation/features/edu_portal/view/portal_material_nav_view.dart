import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/locale_provider.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../../../../data/models/material_models.dart';
import '../../../common_widgets/loading_indicator.dart';
import '../../../common_widgets/status_dialogs.dart';
import '../../../navigation/app_routes.dart';
import '../viewmodel/edu_portal_viewmodel.dart';
import '../viewmodel/exam_viewmodel.dart';

class PortalMaterialNavView extends StatefulWidget {
  const PortalMaterialNavView({super.key});

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

  Future<void> _openResource(
      BuildContext context, String url, String name) async {
    await UrlLauncherHelper.launchExternalUrl(
      context,
      url,
      fallbackTitle: name,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EduPortalViewModel>();
    final langCode = context.watch<LocaleProvider>().locale.languageCode;
    final portalData = viewModel.mainPortal;
    final chapterDetails = portalData?.chapterData;
    final chapters = portalData?.chapters ?? [];
    final activeChapter = chapters.firstWhere(
      (c) => c.pk == viewModel.selectedChapterPk,
      orElse: () => chapters.isNotEmpty
          ? chapters.first
          : Chapter(pk: 0, name: '', complete: false),
    );
    final isUnitCompleted =
        activeChapter.complete || viewModel.isCurrentChapterCompleted;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bgLight,
      drawer: _buildChaptersDrawer(context, viewModel),
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.orange.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppColors.white,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.75),
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              labelStyle: AppTextStyles.cairoBold(fontSize: 13, color: AppColors.white),
              unselectedLabelStyle: AppTextStyles.cairoMedium(fontSize: 13, color: Colors.white70),
              tabs: const [
                Tab(text: 'المحاضرات والمصادر'),
                Tab(text: 'الاختبارات'),
                Tab(text: 'إنهاء الوحدة'),
              ],
            ),
          ),
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
                _buildEndUnitTab(
                    context, viewModel, isUnitCompleted, chapterDetails, langCode),
              ],
            ),
    );
  }

  Widget _buildChaptersDrawer(
    BuildContext context,
    EduPortalViewModel viewModel,
  ) {
    final chapters = viewModel.mainPortal?.chapters ?? [];

    return Drawer(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.horizontal(
          end: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: AppColors.mintSurface,
                border: Border(bottom: BorderSide(color: AppColors.mintBorder)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'فصول المقرر',
                    style: AppTextStyles.cairoExtraBold(
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemCount: chapters.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (ctx, index) {
                  final chapter = chapters[index];
                  final isSelected = viewModel.selectedChapterPk == chapter.pk;

                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.mintSurface
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: isSelected
                          ? Border.all(color: AppColors.mintBorder)
                          : null,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      leading: Icon(
                        chapter.complete
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: chapter.complete ? AppColors.primary : AppColors.textLight,
                        size: 22,
                      ),
                      title: Text(
                        chapter.name,
                        style: AppTextStyles.cairoBold(
                          fontSize: 14,
                          color: isSelected ? AppColors.primary : AppColors.textDark,
                          height: 1.4,
                        ),
                        softWrap: true,
                      ),
                      trailing: chapter.complete
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'مكتملة',
                                style: AppTextStyles.cairoBold(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          : null,
                      onTap: () {
                        viewModel.selectChapter(chapter.pk);
                        Navigator.of(context).pop();
                      },
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

  Widget _buildResourcesTab(BuildContext context, List<dynamic> resources) {
    if (resources.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.mintSurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.menu_book_rounded,
                    size: 48, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(
                'لا توجد محاضرات أو مصادر متاحة لهذا الفصل حالياً',
                style: AppTextStyles.cairoBold(
                    fontSize: 15, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: resources.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, index) {
        final resource = resources[index];
        final name =
            (resource.name as String?)?.trim() ?? 'محاضرة / مصدر دراسي';
        final url = (resource.url as String?) ?? '';

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openResource(context, url, name),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.cardDecoration(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.mintSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.mintBorder),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTextStyles.cairoBold(
                            fontSize: 14.5,
                            color: AppColors.textDark,
                            height: 1.4,
                          ),
                          softWrap: true,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.link_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'اضغط لفتح المحاضرة أو المصدر',
                                style: AppTextStyles.cairoMedium(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.primary,
                      size: 13,
                    ),
                  ),
                ],
              ),
            ),
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppColors.orangeLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(AppIcons.exam, size: 48, color: AppColors.orange),
              ),
              const SizedBox(height: 16),
              Text(
                'لا توجد اختبارات متاحة لهذا الفصل حالياً',
                style: AppTextStyles.cairoBold(
                    fontSize: 15, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: exams.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, index) {
        final exam = exams[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.cardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.orangeLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.orangeBorder),
                    ),
                    child: const Icon(AppIcons.exam, color: AppColors.orange, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exam.name,
                          style: AppTextStyles.cairoBold(
                            fontSize: 15,
                            color: AppColors.textDark,
                            height: 1.4,
                          ),
                          softWrap: true,
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.mintSurface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.mintBorder),
                              ),
                              child: Text(
                                'عدد الأسئلة: ${exam.questions.length}',
                                style: AppTextStyles.cairoBold(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            if (exam.foundAnswers)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      size: 13,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'تم التسليم',
                                      style: AppTextStyles.cairoBold(
                                        fontSize: 11,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (exam.foundAnswers) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.mintSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.mintBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'تم الإجابة وتسليم الامتحان مسبقاً',
                        style: AppTextStyles.cairoBold(
                          fontSize: 13.5,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      context.read<ExamViewModel>().setExam(exam, chapterPk);
                      Navigator.of(context).pushNamed(AppRoutes.examController);
                    },
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: Text(
                      'بدء الاختبار',
                      style: AppTextStyles.cairoBold(
                          fontSize: 14, color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildEndUnitTab(
    BuildContext context,
    EduPortalViewModel viewModel,
    bool isUnitCompleted,
    ChapterDetails? chapterDetails,
    String langCode,
  ) {
    if (isUnitCompleted) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: AppDecorations.cardDecoration(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.mintSurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 56,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'تم إنهاء هذه الوحدة بنجاح',
                  style: AppTextStyles.cairoExtraBold(
                    fontSize: 19,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                const SizedBox(height: 8),
                Text(
                  'لقد أتممت كافة متطلبات هذه الوحدة بنجاح، ولا حاجة لإنهائها مرة أخرى.',
                  style: AppTextStyles.cairoMedium(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                const SizedBox(height: 16),
                Lottie.asset(
                  'assets/lottie/imdone.json',
                  width: 140,
                  height: 110,
                  fit: BoxFit.contain,
                  repeat: false,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Unit Not Completed Yet
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppDecorations.cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (chapterDetails != null &&
                chapterDetails.publishDate.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event_busy_rounded, color: AppColors.red, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'آخر موعد لإنهاء الوحدة: ${chapterDetails.publishDate}',
                        style: AppTextStyles.cairoBold(
                          fontSize: 13,
                          color: AppColors.red,
                          height: 1.4,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              'يرجى التأكد من مشاهدة كافة المحاضرات وقراءة المصادر التعليمية وإتمام الاختبارات قبل تأكيد إنهاء الوحدة.',
              style: AppTextStyles.cairoMedium(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.7,
              ),
              softWrap: true,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.check_circle_outline_rounded,
                    color: AppColors.white),
                onPressed: () async {
                  StatusDialogs.showLoading(context);
                  final success = await viewModel.completeUnit();
                  if (!context.mounted) return;
                  StatusDialogs.hide(context);
                  if (success) {
                    StatusDialogs.showSuccess(
                      context,
                      'تم إنهاء الوحدة بنجاح',
                    );
                  } else {
                    StatusDialogs.showError(
                      context,
                      viewModel.unitEndErrorMessage ??
                          AppStrings.get('unit_end_deadline_exceeded', langCode),
                    );
                  }
                },
                label: Text(
                  'تأكيد إنهاء الوحدة',
                  style: AppTextStyles.cairoBold(
                    fontSize: 15,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
