import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_profile/components/glass_tech_card.dart';
import 'package:my_profile/models/my_project.dart';
import 'package:my_profile/screens/home/components/project_details_dialog.dart';

import '../../../core/app_colors.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    super.key,
    required this.project,
    this.allProjects = const [],
    this.index = 0,
  });

  final MyProject project;
  final List<MyProject> allProjects;
  final int index;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  void _showProjectDetails() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.9),
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return ProjectStackDialog(
            projects: widget.allProjects.isNotEmpty
                ? widget.allProjects
                : [widget.project],
            initialIndex: widget.index,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curve =
              CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic);
          return FadeTransition(
            opacity: curve,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(curve),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _showProjectDetails,
        child: Hero(
          tag: widget.project.id ?? '',
          child: GlassTechCard(
            isHovered: _isHovered,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.project.name?.toUpperCase() ?? "PROJECT_NAME",
                          style: GoogleFonts.shareTechMono(
                            color: AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: _isHovered
                                ? [
                                    Shadow(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.5),
                                        blurRadius: 10)
                                  ]
                                : [],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        widget.project.startTime?.split('/').last ?? "202X",
                        style: GoogleFonts.shareTechMono(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "// ${widget.project.role?.toUpperCase()}",
                    style: GoogleFonts.shareTechMono(
                      color: AppColors.accentYellow.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("TECH_STACK"),
                          const SizedBox(height: 8),
                          _buildShortList(widget.project.techUsed ?? []),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "OPEN_LOG",
                          style: GoogleFonts.shareTechMono(
                            fontSize: 10,
                            color: _isHovered
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 14,
                          color: _isHovered
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        )
                            .animate(target: _isHovered ? 1 : 0)
                            .moveX(begin: -5, end: 0)
                            .fadeIn(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      "> $title",
      style: GoogleFonts.shareTechMono(
        color: AppColors.textSecondary,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildShortList(List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: items
          .take(4)
          .map((item) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  item,
                  style: GoogleFonts.shareTechMono(
                      fontSize: 9,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold),
                ),
              ))
          .toList(),
    );
  }
}
