import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';

import '../../../core/app_dimensions.dart';
import '../../../core/app_text_styles.dart';
import 'project_card.dart';

class MyProjects extends StatelessWidget {
  const MyProjects({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "PROJECTS",
          style: AppTextStyles.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
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

class ProjectsGridView extends StatelessWidget {
  const ProjectsGridView({
    Key? key,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1.3,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

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

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.myProjects.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: AppDimensions.paddingM,
            mainAxisSpacing: AppDimensions.paddingM,
          ),
          itemBuilder: (context, index) => ProjectCard(
            project: state.myProjects[index],
          ),
        );
      },
    );
  }
}