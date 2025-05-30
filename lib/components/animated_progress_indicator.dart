import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_dimensions.dart';
import '../core/app_text_styles.dart';

class AnimatedCircularProgressIndicator extends StatelessWidget {
  const AnimatedCircularProgressIndicator({
    super.key,
    required this.percentage,
    required this.label,
  });

  final double percentage;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: percentage),
            duration: Duration(milliseconds: AppDimensions.animationSlowHigh),
            builder: (context, double value, child) => Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: value,
                  color: AppColors.primary,
                  backgroundColor: AppColors.surfaceDark,
                  strokeWidth: 4,
                ),
                Center(
                  child: AutoSizeText(
                    "${(value * 100).toInt()}%",
                    style: AppTextStyles.bodySmall,
                    minFontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppDimensions.paddingS),
        AutoSizeText(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall,
          minFontSize: 8,
        ),
      ],
    );
  }
}

class AnimatedLinearProgressIndicator extends StatelessWidget {
  const AnimatedLinearProgressIndicator({
    super.key,
    required this.percentage,
    required this.label,
  });

  final double percentage;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: percentage),
        duration: Duration(milliseconds: AppDimensions.animationSlowHigh),
        builder: (context, double value, child) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AutoSizeText(
                    label,
                    minFontSize: 10,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: AppDimensions.paddingS),
                AutoSizeText(
                  "${(value * 100).toInt()}%",
                  minFontSize: 10,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            SizedBox(height: AppDimensions.paddingS),
            LinearProgressIndicator(
              value: value,
              color: AppColors.primary,
              backgroundColor: AppColors.surfaceDark,
              minHeight: 4,
            ),
          ],
        ),
      ),
    );
  }
}
