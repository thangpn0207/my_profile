import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_text_styles.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return AspectRatio(
      aspectRatio: isMobile ? 2.5 : 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Lottie.asset('assets/images/animation_bg.json', fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Discover my information!",
                  style: isDesktop
                      ? AppTextStyles.displaySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
                      : AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (isMobile) SizedBox(height: AppDimensions.paddingS),
                const MyBuildAnimatedText(),
                SizedBox(height: AppDimensions.paddingM),
                // Uncomment if you want to add the button back
                // if (!isMobile)
                //   ElevatedButton(
                //     onPressed: () {},
                //     style: ElevatedButton.styleFrom(
                //       padding: EdgeInsets.symmetric(
                //         horizontal: AppDimensions.paddingXL,
                //         vertical: AppDimensions.paddingM,
                //       ),
                //       backgroundColor: AppColors.primary,
                //       foregroundColor: AppColors.surfaceDark,
                //     ),
                //     child: const Text("EXPLORE NOW"),
                //   ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyBuildAnimatedText extends StatelessWidget {
  const MyBuildAnimatedText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final showFlutterText = !isMobile && !isTablet;

    return DefaultTextStyle(
      style: AppTextStyles.titleMedium,
      maxLines: 1,
      child: Row(
        children: [
          if (showFlutterText) const FlutterCodedText(),
          if (showFlutterText) SizedBox(width: AppDimensions.paddingS),
          const Text("I build "),
          isMobile
              ? const Expanded(child: AnimatedText())
              : const AnimatedText(),
          if (showFlutterText) SizedBox(width: AppDimensions.paddingS),
          if (showFlutterText) const FlutterCodedText(),
        ],
      ),
    );
  }
}

class AnimatedText extends StatelessWidget {
  const AnimatedText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TyperAnimatedText(
          "responsive web and mobile app with flutter",
          speed: Duration(milliseconds: AppDimensions.animationFast ~/ 3),
          textStyle: AppTextStyles.titleMedium,
        ),
      ],
      repeatForever: true,
      pause: const Duration(seconds: 1),
    );
  }
}

class FlutterCodedText extends StatelessWidget {
  const FlutterCodedText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "<",
        style: AppTextStyles.titleMedium,
        children: [
          TextSpan(
            text: "flutter",
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const TextSpan(text: ">"),
        ],
      ),
    );
  }
}