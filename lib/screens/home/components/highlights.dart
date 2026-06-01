import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/components/animated_counter.dart';
import 'package:my_profile/components/glass_container.dart';
import 'package:my_profile/core/app_colors.dart';
import 'package:my_profile/core/project_keys.dart';
import 'package:my_profile/utils/string_util.dart';

import '../../../core/app_dimensions.dart';
import 'highlight.dart';

class HighLightsInfo extends StatelessWidget {
  const HighLightsInfo({
    super.key,
  });

  void _showLanguagesDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (context) => Center(
        child: Container(
          width: 400,
          margin: const EdgeInsets.all(20),
          child: GlassContainer(
            borderRadius: 12,
            opacity: 0.6,
            padding: const EdgeInsets.all(24),
            boxBorder:
                Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "// NATURAL_LANGUAGES",
                      style: GoogleFonts.shareTechMono(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: AppColors.primary, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    thickness: 1),
                const SizedBox(height: 16),
                _buildDialogRow("VIETNAMESE", "NATIVE_SPEAKER "),
                const SizedBox(height: 12),
                _buildDialogRow("ENGLISH", "PROFESSIONAL_WORKING //"),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSkillsDialog(BuildContext context, List<dynamic>? coding) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (context) => Center(
        child: Container(
          width: 450,
          margin: const EdgeInsets.all(20),
          child: GlassContainer(
            borderRadius: 12,
            opacity: 0.6,
            padding: const EdgeInsets.all(24),
            boxBorder:
                Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "// CORE_ENGINEERING_SKILLS",
                      style: GoogleFonts.shareTechMono(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: AppColors.primary, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    thickness: 1),
                const SizedBox(height: 16),
                if (coding != null)
                  ...coding.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "> ${e.name?.toUpperCase() ?? ''}",
                              style: GoogleFonts.shareTechMono(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "${((e.percent ?? 0.0) * 100).toInt()}%",
                              style: GoogleFonts.shareTechMono(
                                color: AppColors.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ))
                else
                  Text(
                    "NO_SKILLS_DUMPED",
                    style: GoogleFonts.shareTechMono(color: AppColors.error),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showExperienceTimelineDialog(BuildContext context, String? expString) {
    int startYear = 2020;
    if (expString != null) {
      try {
        startYear = DateTime.parse(expString).year;
      } catch (_) {}
    }
    final currentYear = DateTime.now().year;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (context) => Center(
        child: Container(
          width: 500,
          margin: const EdgeInsets.all(20),
          child: GlassContainer(
            borderRadius: 12,
            opacity: 0.6,
            padding: const EdgeInsets.all(24),
            boxBorder:
                Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "// EXPERIENCE_CHRONOLOGY",
                      style: GoogleFonts.shareTechMono(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: AppColors.primary, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    thickness: 1),
                const SizedBox(height: 20),

                // Animated Year Counter
                Center(
                  child: Column(
                    children: [
                      // Smaller Chronology Span (e.g., "2020 >>> 2026")
                      TweenAnimationBuilder<int>(
                        tween: IntTween(begin: startYear, end: currentYear),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Text(
                            "$startYear >>> $value",
                            style: GoogleFonts.shareTechMono(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                              letterSpacing: 2,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Very Large Prominent Experience Counter (e.g., "5+ YEARS")
                      TweenAnimationBuilder<int>(
                        tween: IntTween(
                            begin: 0, end: expString.formatStringToExp()),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Text(
                            "$value+",
                            style: GoogleFonts.shareTechMono(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: 2,
                              height: 1.0,
                              shadows: [
                                Shadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.6),
                                  blurRadius: 30,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "YEARS_OF_PROFESSIONAL_EXPERIENCE",
                        style: GoogleFonts.shareTechMono(
                          color: AppColors.primary.withValues(alpha: 0.8),
                          fontSize: 11,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Milestones Timeline
                _buildTimelineNode(
                  "2020",
                  "INTERN_FLUTTER_DEV",
                  "ICheck Product - Product tracking & UI modules",
                  delayMs: 300,
                ),
                _buildTimelineNode(
                  "2021 - 2023",
                  "FLUTTER_DEV",
                  "ITS-Solution - Team leading, SNS logins, map SDKs",
                  delayMs: 600,
                ),
                _buildTimelineNode(
                  "2023 - 2025",
                  "FLUTTER_ENGINEER",
                  "TasTech-Asia - Agility regional clients, PlanTour & Recago",
                  delayMs: 900,
                ),
                _buildTimelineNode(
                  "2025 - PRESENT",
                  "SENIOR_FLUTTER_ENGINEER",
                  "CMC Global - Windows & Smart Board Ecosystem, C++ Interop",
                  delayMs: 1200,
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineNode(String years, String title, String description,
      {required int delayMs, bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator line
          Column(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "[$years]",
                      style: GoogleFonts.shareTechMono(
                        color: AppColors.accentYellow,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.shareTechMono(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.shareTechMono(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delayMs)).slideX(
        begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutQuad);
  }

  Widget _buildDialogRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "> $label:",
          style: GoogleFonts.shareTechMono(
              color: AppColors.textSecondary, fontSize: 14),
        ),
        Text(
          val,
          style: GoogleFonts.shareTechMono(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoBloc, MyInfoState>(
      builder: (context, state) {
        final userInfo = state.userInfo;
        final project = state.myProjects;

        // Check if data is available
        if (userInfo == null) {
          return const SizedBox.shrink();
        }

        void yearsExpTap() {
          _showExperienceTimelineDialog(context, userInfo.exp);
        }

        void projectsTap() {
          if (ProjectKeys.projectsKey.currentContext != null) {
            Scrollable.ensureVisible(
              ProjectKeys.projectsKey.currentContext!,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
            );
          }
        }

        return Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
          child: ResponsiveBreakpoints.of(context).isMobile
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: HighLight(
                            counter: AnimatedCounter(
                              value: userInfo.exp.formatStringToExp(),
                              text: "+",
                            ),
                            label: "Years exp",
                            onTap: yearsExpTap,
                          ),
                        ),
                        SizedBox(width: AppDimensions.paddingM),
                        Expanded(
                          child: HighLight(
                            counter: const AnimatedCounter(
                              value: 2,
                              text: "",
                            ),
                            label: "Languages",
                            onTap: () => _showLanguagesDialog(context),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.paddingM),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: HighLight(
                            counter: AnimatedCounter(
                              value: project.length,
                              text: "+",
                            ),
                            label: "Projects",
                            onTap: projectsTap,
                          ),
                        ),
                        SizedBox(width: AppDimensions.paddingM),
                        Expanded(
                          child: HighLight(
                            counter: AnimatedCounter(
                              value: userInfo.coding?.length ?? 0,
                              text: "",
                            ),
                            label: "Languages Code",
                            onTap: () =>
                                _showSkillsDialog(context, userInfo.coding),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: HighLight(
                        counter: AnimatedCounter(
                          value: userInfo.exp.formatStringToExp(),
                          text: "+",
                        ),
                        label: "Years Exp",
                        onTap: yearsExpTap,
                      ),
                    ),
                    SizedBox(width: AppDimensions.paddingM),
                    Expanded(
                      child: HighLight(
                        counter: const AnimatedCounter(
                          value: 2,
                          text: "",
                        ),
                        label: "Languages",
                        onTap: () => _showLanguagesDialog(context),
                      ),
                    ),
                    SizedBox(width: AppDimensions.paddingM),
                    Expanded(
                      child: HighLight(
                        counter: AnimatedCounter(
                          value: project.length,
                          text: "+",
                        ),
                        label: "Projects",
                        onTap: projectsTap,
                      ),
                    ),
                    SizedBox(width: AppDimensions.paddingM),
                    Expanded(
                      child: HighLight(
                        counter: AnimatedCounter(
                          value: userInfo.coding?.length ?? 0,
                          text: "",
                        ),
                        label: "Languages Code",
                        onTap: () =>
                            _showSkillsDialog(context, userInfo.coding),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
