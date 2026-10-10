import 'dart:async';

import 'package:flutter/material.dart';

import 'package:rayaedu/theme/app_colors.dart';
import 'package:rayaedu/widgets/common/banner_carousel.dart';
import 'package:rayaedu/widgets/common/loop_type_writer.dart';
import 'package:rayaedu/model/data/order.dart';

// ────────────────────────────────────────────────────────────
//  Off-white card background (was AppColors.mainC)
// ────────────────────────────────────────────────────────────
const Color _kCardBg = Color(0xFFF5F5F5);

// ────────────────────────────────────────────────────────────
//  Local mock models
// ────────────────────────────────────────────────────────────
class MockStudent {
  final String name;
  final String photoUrl;
  const MockStudent({required this.name, this.photoUrl = ''});
}

class MockOrder {
  final String img;
  final String link;
  final int id;
  const MockOrder({this.img = '', this.link = '', this.id = 0});
}

class MockAchievements {
  final int countExamChapters;
  final int countExamChaptersDone;
  final double attendanceRate;
  final int countMaterials;
  const MockAchievements({
    this.countExamChapters = 0,
    this.countExamChaptersDone = 0,
    this.attendanceRate = 0,
    this.countMaterials = 0,
  });
}

class MockMaterial {
  final int pk;
  final String name;
  const MockMaterial({required this.pk, required this.name});
}

// ────────────────────────────────────────────────────────────
//  EduPortalPage — pure UI, no network calls
// ────────────────────────────────────────────────────────────
class EduPortalPage extends StatefulWidget {
  const EduPortalPage({super.key});

  @override
  State<EduPortalPage> createState() => _EduPortalPageState();
}

class _EduPortalPageState extends State<EduPortalPage> {
  final MockStudent _student = const MockStudent(
    name: 'اسم الطالب الكامل هنا',
    photoUrl: '',
  );

  final MockAchievements _achievements = const MockAchievements(
    countExamChapters: 12,
    countExamChaptersDone: 7,
    attendanceRate: 82.5,
    countMaterials: 5,
  );

  final List<MockOrder> _banners = const [
    MockOrder(img: 'null', link: '', id: 1),
    MockOrder(img: 'null', link: '', id: 2),
    MockOrder(img: 'null', link: '', id: 3),
  ];

  final List<MockMaterial> _materials = const [
    MockMaterial(pk: 1, name: 'مادة 1 : المحاسبة المالية'),
    MockMaterial(pk: 2, name: 'مادة 2 : التجارة الخارجية'),
    MockMaterial(pk: 3, name: 'مادة 3 : نظم معلومات الأعمال'),
    MockMaterial(pk: 4, name: 'مادة 4 : الإدارة العامة'),
    MockMaterial(pk: 5, name: 'مادة 5 : الرياضيات التطبيقية'),
  ];

  final ValueNotifier<String> _greetingText = ValueNotifier('');
  LoopTypeWriter? _typeWriter;

  @override
  void initState() {
    super.initState();
    _startGreetingLoop();
  }

  @override
  void dispose() {
    _typeWriter?.stop();
    _greetingText.dispose();
    super.dispose();
  }

  void _startGreetingLoop() {
    const list = ['رمضان كريم🌙', 'معهد راية العالي'];
    _typeWriter = LoopTypeWriter(
      notifier: _greetingText,
      strings: list,
      typingDelay: const Duration(milliseconds: 100),
      pauseDelay: const Duration(seconds: 3),
    )..start();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openMaterial(MockMaterial m) {
    _showSnack('فتح المادة : ${m.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: RefreshIndicator(
        color: AppColors.mainC,
        backgroundColor: AppColors.white,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 800));
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── HEADER (avatar right, text left) ──
                    _Header(
                      student: _student,
                      greeting: _greetingText,
                    ),

                    // ── BODY ───────────────────────────────
                    _Body(
                      achievements: _achievements,
                      banners: _banners,
                      bannerLoading: false,
                      materials: _materials,
                      onBannerTap: (_) => _showSnack('فتح الإعلان'),
                      onMaterialTap: _openMaterial,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  HEADER — avatar on the RIGHT, text on the LEFT
// ════════════════════════════════════════════════════════════
class _Header extends StatelessWidget {
  final MockStudent? student;
  final ValueNotifier<String> greeting;

  const _Header({required this.student, required this.greeting});

  @override
  Widget build(BuildContext context) {
    final name = student?.name ?? '';
    final display = name.length > 30 ? '${name.substring(0, 30)}...' : name;

    return Container(
      height: 111,
      color: AppColors.mainC,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          // ── Avatar — pinned to the RIGHT edge ──────────
          const Positioned(
            top: 20,
            right: 0,
            child: _StudentAvatar(size: 70),
          ),

          // ── Greeting + name — to the LEFT of the avatar
          Positioned(
            top: 25,
            right: 93, // 70 (avatar) + ~23 gap
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 35,
                  child: ValueListenableBuilder<String>(
                    valueListenable: greeting,
                    builder: (_, value, __) => Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  display,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  STUDENT AVATAR
// ════════════════════════════════════════════════════════════
class _StudentAvatar extends StatelessWidget {
  final double size;
  const _StudentAvatar({required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          'assets/imgs/profile.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: size,
            height: size,
            color: Colors.white24,
            child: Icon(
              Icons.person,
              size: size * 0.6,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  BODY
// ════════════════════════════════════════════════════════════
class _Body extends StatelessWidget {
  final MockAchievements achievements;
  final List<MockOrder> banners;
  final bool bannerLoading;
  final List<MockMaterial> materials;
  final ValueChanged<MockOrder> onBannerTap;
  final ValueChanged<MockMaterial> onMaterialTap;

  const _Body({
    required this.achievements,
    required this.banners,
    required this.bannerLoading,
    required this.materials,
    required this.onBannerTap,
    required this.onMaterialTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              children: [
                BannerCarousel(
                  banners: banners
                      .map((b) => Order(
                    img: b.img,
                    link: b.link,
                    id: b.id,
                  ))
                      .toList(),
                  onTap: (_) => onBannerTap(banners.first),
                  height: 100,
                ),
                if (bannerLoading) ...[
                  const SizedBox(height: 8),
                  const SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: AppColors.icoFive,
                      strokeWidth: 3,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Stats row ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: _StatBox(
                    imageAsset: 'assets/imgs/test.png',
                    text:
                    'عدد الاختبارات : ${achievements.countExamChapters}',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatBox(
                    imageAsset: 'assets/imgs/passed.png',
                    text:
                    'الاختبارات المجتازة : ${achievements.countExamChaptersDone}',
                  ),
                ),
              ],
            ),
          ),

          // ── Attendance card ────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _AttendanceCard(
              attendanceRate: achievements.attendanceRate,
            ),
          ),

          // ── Study materials ────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'المواد الدراسية : ${achievements.countMaterials}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: AppColors.mainC,
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: materials.length,
                  itemBuilder: (_, i) => _MaterialTile(
                    material: materials[i],
                    onTap: () => onMaterialTap(materials[i]),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  STAT BOX — off-white bg, mainC icon + text
// ════════════════════════════════════════════════════════════
class _StatBox extends StatelessWidget {
  final String imageAsset;
  final String text;

  const _StatBox({required this.imageAsset, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _kCardBg,                                 // ← off-white
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mainC.withOpacity(0.08)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageAsset,
            width: 30,
            height: 30,
            color: AppColors.mainC,                      // ← mainC tint
            errorBuilder: (_, __, ___) => const Icon(
              Icons.assignment_outlined,
              size: 30,
              color: AppColors.mainC,                    // ← mainC icon
            ),
          ),
          const SizedBox(height: 5),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: AppColors.mainC,                  // ← mainC text
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  ATTENDANCE CARD — off-white bg, mainC text + progress
// ════════════════════════════════════════════════════════════
class _AttendanceCard extends StatelessWidget {
  final double attendanceRate;

  const _AttendanceCard({required this.attendanceRate});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _kCardBg,                                 // ← off-white
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mainC.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'نسبة الحضور : ${attendanceRate.toStringAsFixed(2)}%',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: AppColors.mainC,                    // ← mainC text
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: (attendanceRate / 100).clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: AppColors.mainC.withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.mainC,                         // ← mainC bar
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  MATERIAL TILE — off-white bg, mainC text, LEFT-pointing arrow
// ════════════════════════════════════════════════════════════
class _MaterialTile extends StatelessWidget {
  final MockMaterial material;
  final VoidCallback onTap;

  const _MaterialTile({required this.material, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _kCardBg,                               // ← off-white
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.mainC.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            // Left arrow — always points left.
            const Icon(
              Icons.arrow_back,                          // ← LEFT arrow
              size: 20,
              color: AppColors.mainC,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                material.name,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppColors.mainC,                // ← mainC text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}