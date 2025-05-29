import 'package:flutter/material.dart';
import 'package:my_profile/core/app_dimensions.dart';

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
      builder: (context, value, child) => Column(
        children: [
          Text(
            "$value$text",
            style: Theme.of(context)
                .textTheme
                .headlineMedium,
          ),
        ],
      ),
    );
  }
}
