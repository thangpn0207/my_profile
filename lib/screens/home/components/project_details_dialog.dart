import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_profile/components/glass_tech_card.dart';
import 'package:my_profile/models/my_project.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/app_colors.dart';

class ProjectStackDialog extends StatefulWidget {
  final List<MyProject> projects;
  final int initialIndex;

  const ProjectStackDialog({
    super.key,
    required this.projects,
    required this.initialIndex,
  });

  @override
  State<ProjectStackDialog> createState() => _ProjectStackDialogState();
}

class _ProjectStackDialogState extends State<ProjectStackDialog> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final isMobile = ResponsiveBreakpoints.of(context).isMobile;
      _pageController = PageController(
        initialPage: widget.initialIndex,
        viewportFraction: isMobile ? 0.9 : 0.7,
      );
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) return const SizedBox.shrink();

    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. Background Tap to close (Behind everything)
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.transparent),
          ),

          // 2. Main PageView Content
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.projects.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final project = widget.projects[index];
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * .25)).clamp(0.0, 1.0);
                    }
                    return Center(
                      child: Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value,
                          child: Hero(
                            tag: index == widget.initialIndex
                                ? (project.id ?? '')
                                : 'none_$index',
                            child: _buildDetailsCard(project, isMobile),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 3. Navigation UI (ON TOP)
          if (!isMobile) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: _buildNavButton(Icons.arrow_back_ios_new, () {
                  _pageController.previousPage(
                      duration: 500.ms, curve: Curves.easeOutCubic);
                }),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: _buildNavButton(Icons.arrow_forward_ios, () {
                  _pageController.nextPage(
                      duration: 500.ms, curve: Curves.easeOutCubic);
                }),
              ),
            ),
          ],

          // 4. Header UI (Close & Info)
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "LOG_ENTRY: 0x${(_currentIndex + 1).toRadixString(16).padLeft(2, '0').toUpperCase()}",
                    style: GoogleFonts.shareTechMono(
                        color: AppColors.primary,
                        fontSize: 16,
                        letterSpacing: 2),
                  ).animate().fadeIn().slideX(),
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: AppColors.primary, size: 32),
                    onPressed: () => Navigator.pop(context),
                  ).animate().fadeIn().rotate(),
                ],
              ),
            ),
          ),

          // 5. Footer Status
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "DATA_STREAM_TOTAL: ${widget.projects.length} // ACTIVE_NODE: ${_currentIndex + 1}",
                style: GoogleFonts.shareTechMono(
                  color: AppColors.primary.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primary, size: 30),
        onPressed: onTap,
        hoverColor: AppColors.primary.withValues(alpha: 0.1),
      ),
    );
  }

  Widget _buildDetailsCard(MyProject project, bool isMobile) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 850,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: GlassTechCard(
          isHovered: true,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 24 : 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name?.toUpperCase() ?? "PROJECT_LOG",
                  style: GoogleFonts.shareTechMono(
                    color: AppColors.primary,
                    fontSize: isMobile ? 22 : 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "// SOURCE_ORG: ${project.company?.toUpperCase()}",
                  style: GoogleFonts.shareTechMono(
                    color: AppColors.accentYellow.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
                Text(
                  "// ASSIGNED_ROLE: ${project.role?.toUpperCase()}",
                  style: GoogleFonts.shareTechMono(
                    color: AppColors.accentYellow.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 32),
                _buildSection("TECH_STACK", project.techUsed ?? []),
                const SizedBox(height: 20),
                _buildSection("LOG_DEPENDENCIES", project.dependencies ?? []),
                const SizedBox(height: 20),
                _buildSection("CONTRIBUTION_LOGS", project.tasks ?? []),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "> [FIELD]: $title",
          style: GoogleFonts.shareTechMono(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text("• ",
                        style:
                            TextStyle(color: AppColors.primary, fontSize: 12)),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: GoogleFonts.shareTechMono(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
