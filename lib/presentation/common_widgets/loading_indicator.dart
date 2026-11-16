import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final double size;
  final Color color;

  const LoadingIndicatorWidget({
    Key? key,
    this.size = 46.0,
    this.color = AppColors.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size + 24,
        height: size + 24,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3.5,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: AppColors.mintSurface,
          ),
        ),
      ),
    );
  }
}
