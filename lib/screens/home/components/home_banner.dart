import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({
    super.key,
  });

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  double _scrollOffset = 0;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          setState(() {
            _scrollOffset = notification.metrics.pixels;
          });
        }
        return true;
      },
      child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : AppDimensions.paddingL,
            vertical: isMobile ? 40 : AppDimensions.paddingXXL,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          ),
          child: Stack(
            children: [
              // Parallax Background Icon
              Positioned(
                right: -50,
                top: -50 + (_scrollOffset * 0.2),
                child: Opacity(
                  opacity: 0.05,
                  child: Icon(Icons.code, size: 300, color: AppColors.primary),
                ),
              ),

              if (isMobile)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTechAvatar(70),
                    const SizedBox(height: 30),
                    _buildIdentityInfo(context, true),
                  ],
                )
              else
                Row(
                  children: [
                    Transform.translate(
                      offset: Offset(0, _scrollOffset * 0.1),
                      child: _buildTechAvatar(isTablet ? 90 : 120),
                    ),
                    SizedBox(width: isTablet ? 30 : 60),
                    Expanded(child: _buildIdentityInfo(context, false)),
                  ],
                ),
            ],
          ),
        ).animate().fadeIn(duration: 800.ms);
      }),
    );
  }

  Widget _buildTechAvatar(double radius) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsating Aura
        Container(
          width: (radius * 2) + 60,
          height: (radius * 2) + 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.05),
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.1, 1.1),
              duration: 3.seconds,
              curve: Curves.easeInOut,
            )
            .blur(begin: const Offset(10, 10), end: const Offset(20, 20)),

        // Outer rotating HUB ring (Faster and with dots)
        Container(
          width: (radius * 2) + 40,
          height: (radius * 2) + 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Stack(
            children: List.generate(
                8,
                (i) => Positioned(
                      left: (radius + 20) +
                          (radius + 20) * (0.8 * (i % 2 == 0 ? 1 : -1)),
                      top: (radius + 20),
                      child: Container(
                          width: 4, height: 4, color: AppColors.primary),
                    )),
          ),
        ).animate(onPlay: (c) => c.repeat()).rotate(duration: 8.seconds),

        // Animated Brackets (Breathing effect)
        ...List.generate(4, (index) {
          final isTop = index < 2;
          final isLeft = index % 2 == 0;
          return Positioned(
            top: isTop ? -10 : null,
            bottom: isTop ? null : -10,
            left: isLeft ? -10 : null,
            right: isLeft ? null : -10,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                border: Border(
                  top: isTop
                      ? const BorderSide(color: AppColors.primary, width: 2)
                      : BorderSide.none,
                  bottom: isTop
                      ? BorderSide.none
                      : const BorderSide(color: AppColors.primary, width: 2),
                  left: isLeft
                      ? const BorderSide(color: AppColors.primary, width: 2)
                      : BorderSide.none,
                  right: isLeft
                      ? BorderSide.none
                      : const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).move(
                begin: Offset(isLeft ? 5 : -5, isTop ? 5 : -5),
                end: const Offset(0, 0),
                duration: 1.5.seconds,
                curve: Curves.easeInOut,
              );
        }),

        // Scan Line Animation
        Container(
          width: (radius * 2),
          height: 2,
          color: AppColors.primary.withValues(alpha: 0.4),
        )
            .animate(onPlay: (c) => c.repeat())
            .moveY(
              begin: -radius,
              end: radius,
              duration: 2.seconds,
              curve: Curves.linear,
            )
            .fadeOut(duration: 200.ms, begin: 1),

        // Main Avatar
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.6), width: 1),
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundImage: const AssetImage('assets/images/avatar_cv.png'),
            backgroundColor: AppColors.background,
          ),
        )
            .animate()
            .scale(duration: 600.ms, curve: Curves.easeOutBack)
            .shimmer(delay: 2.seconds, duration: 2.seconds),
      ],
    );
  }

  Widget _buildIdentityInfo(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              color: AppColors.primary,
              child: Text(
                "ID_VERIFIED",
                style: GoogleFonts.shareTechMono(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .shimmer(duration: 2.seconds, color: Colors.white24),
            const SizedBox(width: 10),
            Text(
              "ACCESS_GRANTED",
              style: GoogleFonts.shareTechMono(
                  color: AppColors.success, fontSize: 10),
            )
                .animate(onPlay: (c) => c.repeat())
                .fadeIn(duration: 1.seconds)
                .fadeOut(delay: 800.ms),
          ],
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 16),
        Text(
          "PHẠM NGỌC THẮNG",
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.shareTechMono(
            fontSize: isMobile ? 28 : 52,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 2,
            height: 1.1,
            shadows: [
              Shadow(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  blurRadius: 20),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.05, end: 0),
        const SizedBox(height: 12),
        Text(
          "SENIOR_FLUTTER_ENGINEER // WINDOWS_SMARTBOARD",
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.shareTechMono(
            fontSize: isMobile ? 12 : 18,
            color: AppColors.primary,
            letterSpacing: 1.5,
          ),
        ).animate().fadeIn(delay: 600.ms),
        const SizedBox(height: 32),
        const MyBuildAnimatedText(),
      ],
    );
  }
}

class MyBuildAnimatedText extends StatelessWidget {
  const MyBuildAnimatedText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return DefaultTextStyle(
      style: GoogleFonts.shareTechMono(
        fontSize: isMobile ? 12 : 16,
        color: AppColors.textPrimary.withValues(alpha: 0.8),
      ),
      child: Row(
        mainAxisAlignment:
            isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          const Text("> "),
          Expanded(
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText("WINDOWS_&_SMARTBOARD_ECOSYSTEMS",
                    speed: const Duration(milliseconds: 40)),
                TyperAnimatedText("HIGH_PERFORMANCE_DESKTOP_UI",
                    speed: const Duration(milliseconds: 40)),
                TyperAnimatedText("CROSS_PLATFORM_INTEGRATION",
                    speed: const Duration(milliseconds: 40)),
              ],
              repeatForever: true,
            ),
          ),
        ],
      ),
    );
  }
}
