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

    return AspectRatio(
      aspectRatio: isMobile ? 2.5 : 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Lottie.asset('assets/images/animation_bg.json', fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
            child: isMobile
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 52,
                          backgroundImage:
                              AssetImage('assets/images/avatar_cv.png'),
                          backgroundColor: Colors.transparent,
                        ),
                        // Add drop shadow
                        foregroundImage: null,
                      ),
                      SizedBox(height: AppDimensions.paddingM),
                      Text(
                        "Pham Ngoc Thang",
                        style: AppTextStyles.displaySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppDimensions.paddingS),
                      Text(
                        "Flutter Developer | UI/UX Enthusiast",
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppDimensions.paddingM),
                      const MyBuildAnimatedText(),
                      SizedBox(height: AppDimensions.paddingM),
                      // Removed action buttons to prevent mobile UI breaking
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar with drop shadow
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 72,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 68,
                            backgroundImage:
                                AssetImage('assets/images/avatar_cv.png'),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                      SizedBox(width: AppDimensions.paddingXXL),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Pham Ngoc Thang",
                              style: AppTextStyles.displayMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: AppDimensions.paddingS),
                            Text(
                              "Flutter Developer | UI/UX Enthusiast",
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: AppDimensions.paddingM),
                            const MyBuildAnimatedText(),
                            SizedBox(height: AppDimensions.paddingL),
                            // Removed action buttons to prevent mobile UI breaking
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
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
