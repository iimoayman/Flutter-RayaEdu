import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rayaedu/model/data/studentAchievments.dart';
import 'package:rayaedu/model/network/achievements.dart';
import 'package:rayaedu/theme/app_colors.dart';
import 'package:rayaedu/widgets/common/attendanceProgressCard.dart';

class EduPortalPage extends StatefulWidget {
  const EduPortalPage({super.key});

  @override
  State<EduPortalPage> createState() => _EduPortalPageState();
}

class _EduPortalPageState extends State<EduPortalPage> {
  final AchievementsService _service = AchievementsService();

  StudentAchievements? _achievements;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (_achievements == null) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final result = await _service.fetch();
      if (!mounted) return;
      setState(() {
        _achievements = result;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (_achievements == null) {
          _error = e.toString().replaceFirst('Exception: ', '');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.mainC,
      backgroundColor: AppColors.white,
      displacement: 40,
      onRefresh: _load,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: _buildContent(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    // ── 1) First-time load ────────────────────────────────────
    if (_achievements == null && _loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: CircularProgressIndicator(color: AppColors.mainC),
        ),
      );
    }

    // ── 2) First-time error ───────────────────────────────────
    if (_achievements == null && _error != null) {
      return _ErrorState(
        message: _error!,
        onRetry: _load,
      );
    }

    // ── 3) Normal state ───────────────────────────────────────
    final a = _achievements!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),

        // ── Row 1: two stat boxes ─────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: Icons.assignment_outlined,
                  value: '${a.countExamChapters}',
                  label: 'عدد الامتحانات',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  icon: Icons.check_circle_outline,
                  value: '${a.countExamChaptersDone}',
                  label: 'الامتحانات المنتهية',
                ),
              ),
            ],
          ),
        ),

        // ── Row 2: attendance card ────────────────────────────
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AttendanceProgressCard(
            key: ValueKey(a.attendanceRate),
            attendanceRate: a.attendanceRate,
          ),
        ),

        // ── Row 3: QR actions ─────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
          child: Row(
            children: [
              Expanded(
                child: _ActionBox(
                  label: 'كود الـ QR الخاص بي',
                  trailingIcon: Icons.qr_code_2,
                  trailingSize: 35,
                  onTap: () {/* TODO: show QR dialog */},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionBox(
                  label: 'مسح رمز الـ QR',
                  trailingIcon: Icons.arrow_back_ios_new,
                  trailingSize: 20,
                  onTap: () {/* TODO: scan QR */},
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────
//  NEW: Error state with Lottie animation on top
// ────────────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    // ── Center takes the full (min-height) space and places the
    //    Column right in the middle of it. ────────────────────────
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min, // still min — OK now
          children: [
            Lottie.asset(
              'assets/lottie/access_denied.json',
              width: 180,
              height: 180,
              repeat: true,
              animate: true,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.block,
                size: 120,
                color: AppColors.mainC,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.mainC,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: AppColors.mainC),
              label: const Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w800,
                  color: AppColors.mainC,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ────────────────────────────────────────────────────────────
//  Stat box (unchanged)
// ────────────────────────────────────────────────────────────
class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$value $label',
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.mainC,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: AppColors.white),
            const SizedBox(height: 5),
            Flexible(
              child: Text(
                '$value\n$label',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────
//  Action box (unchanged)
// ────────────────────────────────────────────────────────────
class _ActionBox extends StatelessWidget {
  const _ActionBox({
    required this.label,
    required this.trailingIcon,
    required this.trailingSize,
    required this.onTap,
  });

  final String label;
  final IconData trailingIcon;
  final double trailingSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: AppColors.mainC,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white.withOpacity(0.08),
          child: Container(
            constraints: const BoxConstraints(minHeight: 80),
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  trailingIcon,
                  size: trailingSize,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}