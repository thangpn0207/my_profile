import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_profile/models/my_project.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_text_styles.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    Key? key,
    required this.project,
  }) : super(key: key);

  final MyProject project;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: AppDimensions.elevationS,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ItemTitle(
              title: project.name ?? '',
              time: '${project.startTime}-${project.endTime}',
            ),
            SizedBox(height: AppDimensions.paddingS),
            _ItemInfo(
              title: 'Company',
              info: project.company ?? "",
            ),
            SizedBox(height: AppDimensions.paddingXS),
            _ItemInfo(
              title: 'Role',
              info: project.role ?? "",
            ),
            SizedBox(height: AppDimensions.paddingXS),
            _ItemInfoList(
              title: 'Tech used',
              moreInfo: project.techUsed ?? [],
            ),
            SizedBox(height: AppDimensions.paddingXS),
            _ItemInfoList(
              title: 'Dependencies',
              moreInfo: project.dependencies ?? [],
            ),
            SizedBox(height: AppDimensions.paddingXS),
            _ItemInfoList(
              title: 'Tasks',
              moreInfo: project.tasks ?? [],
            ),
            // Uncomment if you want to add the read more button
            // SizedBox(height: AppDimensions.paddingS),
            // TextButton(
            //   onPressed: () {},
            //   child: Text(
            //     "Read More >>",
            //     style: AppTextStyles.labelMedium.copyWith(
            //       color: AppColors.primary,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _ItemTitle extends StatelessWidget {
  const _ItemTitle({
    Key? key,
    required this.title,
    required this.time,
  }) : super(key: key);

  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          minFontSize: 12,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: AppDimensions.paddingXS),
        AutoSizeText(
          time,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
          minFontSize: 10,
        ),
      ],
    );
  }
}

class _ItemInfo extends StatelessWidget {
  const _ItemInfo({
    Key? key,
    required this.title,
    required this.info,
  }) : super(key: key);

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.paddingXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "◦ $title: ",
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: AutoSizeText(
              info,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              minFontSize: 10,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemInfoList extends StatelessWidget {
  const _ItemInfoList({
    Key? key,
    required this.title,
    required this.moreInfo,
  }) : super(key: key);

  final String title;
  final List<String> moreInfo;

  @override
  Widget build(BuildContext context) {
    if (moreInfo.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.paddingXS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "◦ $title:",
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppDimensions.paddingXS / 2),
          Padding(
            padding: EdgeInsets.only(left: AppDimensions.paddingS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: moreInfo
                  .map((item) => Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: AutoSizeText(
                  "• $item",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  minFontSize: 9,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}