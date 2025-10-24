import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_text_styles.dart';
import 'project_card.dart';

class MyProjects extends StatefulWidget {
  const MyProjects({
    Key? key,
  }) : super(key: key);

  @override
  State<MyProjects> createState() => _MyProjectsState();
}

class _MyProjectsState extends State<MyProjects>
    with SingleTickerProviderStateMixin {
  bool _showAllProjects = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: AppDimensions.animationNormal),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
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
                AppColors.primary.withOpacity(0.1),
                Colors.transparent,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Row(
            children: [
              Icon(
                Icons.work_outline,
                color: AppColors.primary,
                size: AppDimensions.iconL,
              ),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                "PROJECTS",
                style: AppTextStyles.headlineMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
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
        childAspectRatio: 1.7,
      );
    } else if (breakpoints.isTablet) {
      return const ProjectsGridView(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
      );
    } else {
      return const ProjectsGridView(
        crossAxisCount: 3,
        childAspectRatio: 1.3,
      );
    }
  }
}

class ProjectsGridView extends StatefulWidget {
  const ProjectsGridView({
    Key? key,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1.3,
  }) : super(key: key);

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
      duration: Duration(milliseconds: AppDimensions.animationNormal),
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
                'No projects available',
                style: AppTextStyles.bodyLarge,
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
              ),
            ),
            if (hasMoreProjects) ...[
              SizedBox(height: AppDimensions.paddingL),
              Center(
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 3.14159,
                      child: ElevatedButton(
                        onPressed: _toggleProjects,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingXL,
                            vertical: AppDimensions.paddingM,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusL),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.surfaceDark,
                              size: AppDimensions.iconM,
                            ),
                            SizedBox(width: AppDimensions.paddingS),
                            Flexible(
                              child: Text(
                                _showAllProjects
                                    ? "Show Less"
                                    : "See More Projects",
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.surfaceDark,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
