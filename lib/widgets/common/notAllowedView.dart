import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rayaedu/theme/app_colors.dart';


class NotAllowedView extends StatelessWidget {
  const NotAllowedView({
    super.key,
    this.message = 'ليس لديك الصلاحية الان',
    this.lottieAsset = 'assets/lottie/access_denied.json',
    this.animationSize = 200,
    this.textColor = AppColors.mainC,
  });

  final String message;
  final String lottieAsset;
  final double animationSize;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              lottieAsset,
              width: animationSize,
              height: animationSize,
              repeat: true,
              animate: true,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.block,
                size: animationSize * 0.7,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: textColor,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}