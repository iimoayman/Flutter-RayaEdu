import 'package:flutter/material.dart';

import 'package:rayaedu/theme/app_colors.dart';

class AttendanceProgressCard extends StatelessWidget {
  const AttendanceProgressCard({
    super.key,
    required this.attendanceRate,
    this.titleBuilder,
    this.animateFrom = 100,
    this.duration = const Duration(milliseconds: 1000),
  });

  final double attendanceRate;
  final String Function(double rate)? titleBuilder;
  final double animateFrom;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final target = attendanceRate.clamp(0.0, 100.0);

    final title = titleBuilder?.call(target) ??
        'نسبة الحضور في المواد (${target.toStringAsFixed(0)}%)';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 70,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.mainC,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: SizedBox(
                height: 10,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: animateFrom, end: target),
                  duration: duration,
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return LinearProgressIndicator(
                      value: value / 100.0,
                      minHeight: 10,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.icoFive,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}