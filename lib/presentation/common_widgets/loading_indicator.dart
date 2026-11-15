import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final double size;
  final Color color;

  const LoadingIndicatorWidget({
    Key? key,
    this.size = 50.0,
    this.color = AppColors.mainC,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3.5,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}
