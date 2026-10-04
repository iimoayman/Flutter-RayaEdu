import 'package:flutter/material.dart';

import 'package:rayaedu/theme/app_colors.dart';

class EduPortalHomeHeader extends StatelessWidget {
  const EduPortalHomeHeader({
    super.key,
    required this.examsCount,
    required this.examsPassed,
    required this.onShowQrCode,
    required this.onGoToScan,
    this.examsCountLabel = 'عدد الامتحانات',
    this.examsPassedLabel = 'الامتحانات المنتهية',
    this.myQrLabel = 'كود الـ QR الخاص بي',
    this.scanQrLabel = 'مسح رمز الـ QR',
  });

  final String examsCount;
  final String examsPassed;
  final String examsCountLabel;
  final String examsPassedLabel;
  final String myQrLabel;
  final String scanQrLabel;
  final VoidCallback onShowQrCode;
  final VoidCallback onGoToScan;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Row 1: two stat boxes ──────────────────────────────
        // android:layout_marginHorizontal="10dp"
        // android:layout_marginBottom="10dp"
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: Icons.assignment_outlined,   // ← replace with @drawable/test
                  label: examsCount,
                  subLabel: examsCountLabel,
                ),
              ),
              const SizedBox(width: 10),            // <View 10dp>
              Expanded(
                child: _StatBox(
                  icon: Icons.check_circle_outline,  // ← replace with @drawable/passed
                  label: examsPassed,
                  subLabel: examsPassedLabel,
                ),
              ),
            ],
          ),
        ),

        // ── Row 2: QR actions ─────────────────────────────────
        // android:layout_marginBottom="20dp"
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
          child: Row(
            children: [
              Expanded(
                child: _ActionBox(
                  label: myQrLabel,
                  trailingIcon: Icons.qr_code_2,          // @drawable/qr_code
                  trailingSize: 35,
                  onTap: onShowQrCode,
                  contentDescription: 'Open my QR code',
                ),
              ),
              const SizedBox(width: 10),                   // <View 10dp>
              Expanded(
                child: _ActionBox(
                  label: scanQrLabel,
                  trailingIcon: Icons.arrow_back_ios_new,  // @drawable/arrow (RTL → left)
                  trailingSize: 20,
                  onTap: onGoToScan,
                  contentDescription: 'Go to scan QR',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────
//  Single stat box — matches:
//    LinearLayout 80dp, padding 10dp, weight 1, centered
//    ImageView 30dp + TextView below (12sp, cairoblack)
// ────────────────────────────────────────────────────────────
class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.icon,
    required this.label,
    required this.subLabel,
  });

  final IconData icon;
  final String label;
  final String subLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label $subLabel',
      child: Container(
        height: 80,                                 // android:layout_height="80dp"
        padding: const EdgeInsets.all(10),          // android:padding="10dp"
        decoration: BoxDecoration(
          color: AppColors.mainC,                   // @drawable/bg_3 tinted main_c
          borderRadius: BorderRadius.circular(12),  // adjust to match bg_3
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: AppColors.white),
            const SizedBox(height: 5),              // android:layout_marginTop="5dp"
            Flexible(
              child: Text(
                '$label\n$subLabel',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  height: 1.15,
                  fontWeight: FontWeight.w900,      // cairoblack ≈ w900
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
//  Action box — matches ConstraintLayout with text (start)
//  and icon (end), minHeight 80dp
// ────────────────────────────────────────────────────────────
class _ActionBox extends StatelessWidget {
  const _ActionBox({
    required this.label,
    required this.trailingIcon,
    required this.trailingSize,
    required this.onTap,
    this.contentDescription,
  });

  final String label;
  final IconData trailingIcon;
  final double trailingSize;
  final VoidCallback onTap;
  final String? contentDescription;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: contentDescription ?? label,
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
                // Text at start (RTL → right)
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
                // Icon at end (RTL → left)
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