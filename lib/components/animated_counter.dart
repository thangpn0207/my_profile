import 'package:flutter/material.dart';
import 'package:my_profile/core/app_dimensions.dart';
import 'package:my_profile/core/app_colors.dart';

class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    Key? key,
    required this.value,
    this.text,
  }) : super(key: key);

  final int value;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: IntTween(begin: 0, end: value),
      duration: Duration(milliseconds: AppDimensions.animationSlowHigh),
      builder: (context, animatedValue, child) {
        return TweenAnimationBuilder<Color?>(
          tween:
              ColorTween(begin: AppColors.primaryLight, end: AppColors.primary),
          duration: Duration(milliseconds: AppDimensions.animationSlowHigh),
          builder: (context, color, _) => Column(
            children: [
              Text(
                "${animatedValue}${text ?? ''}",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                      shadows: [
                        Shadow(
                          color: color!.withOpacity(0.6),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ) ??
                    TextStyle(),
              ),
            ],
          ),
        );
      },
    );
  }
}
