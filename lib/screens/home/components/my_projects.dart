import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import 'project_card.dart';

class MyProjects extends StatelessWidget {
  const MyProjects({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                Colors.transparent,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.code,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                "PROJECT_LOGS",
                style: GoogleFonts.shareTechMono(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.paddingM),
        _buildResponsiveGrid(context),
      ],
    );
  }

  Widget _buildResponsiveGrid(BuildContext context) {
    final breakpoints = ResponsiveBreakpoints.of(context);

    if (breakpoints.isMobile) {
      return const ProjectsGridView(
        crossAxisCount: 1,
        childAspectRatio: 1.5,
      );
    } else if (breakpoints.isTablet) {
      return const ProjectsGridView(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
      );
    } else {
      return const ProjectsGridView(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
      );
    }
  }
}

class ProjectsGridView extends StatefulWidget {
  const ProjectsGridView({
    super.key,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1.3,
  });

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<ProjectsGridView> createState() => _ProjectsGridViewState();
}

class _ProjectsGridViewState extends State<ProjectsGridView>
    with SingleTickerProviderStateMixin {
  bool _showAllProjects = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleProjects() {
    setState(() {
      _showAllProjects = !_showAllProjects;
    });
    if (_showAllProjects) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoBloc, MyInfoState>(
      builder: (context, state) {
        if (state.myProjects.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.paddingXL),
              child: Text(
                'ERROR: NO_PROJECTS_LOADED',
                style: GoogleFonts.shareTechMono(color: AppColors.error),
              ),
            ),
          );
        }

        final displayProjects = _showAllProjects
            ? state.myProjects
            : state.myProjects.take(6).toList();
        final hasMoreProjects = state.myProjects.length > 6;

        return Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayProjects.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                childAspectRatio: widget.childAspectRatio,
                crossAxisSpacing: AppDimensions.paddingM,
                mainAxisSpacing: AppDimensions.paddingM,
              ),
              itemBuilder: (context, index) => ProjectCard(
                project: displayProjects[index],
                allProjects: displayProjects,
                index: index,
              ),
            ),
            if (hasMoreProjects) ...[
              const SizedBox(height: 20),
              Center(
                child: OutlinedButton(
                  onPressed: _toggleProjects,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RotationTransition(
                        turns: _rotationAnimation,
                        child: const Icon(Icons.keyboard_arrow_down),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _showAllProjects ? "COLLAPSE_LOGS" : "EXPAND_FULL_LOGS",
                        style: GoogleFonts.shareTechMono(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
