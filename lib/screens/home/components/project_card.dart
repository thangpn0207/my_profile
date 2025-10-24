import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_profile/models/my_project.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_text_styles.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    Key? key,
    required this.project,
  }) : super(key: key);

  final MyProject project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
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

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

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
              title: widget.project.name ?? '',
              time: '${widget.project.startTime}-${widget.project.endTime}',
            ),
            SizedBox(height: AppDimensions.paddingS),
            _ItemInfo(
              title: 'Company',
              info: widget.project.company ?? "",
            ),
            SizedBox(height: AppDimensions.paddingXS),
            _ItemInfo(
              title: 'Role',
              info: widget.project.role ?? "",
            ),
            SizedBox(height: AppDimensions.paddingXS),
            _ItemInfoList(
              title: 'Tech used',
              moreInfo: widget.project.techUsed ?? [],
              isExpanded: _isExpanded,
            ),
            SizedBox(height: AppDimensions.paddingXS),
            _ItemInfoList(
              title: 'Dependencies',
              moreInfo: widget.project.dependencies ?? [],
              isExpanded: _isExpanded,
            ),
            SizedBox(height: AppDimensions.paddingXS),
            _ItemInfoList(
              title: 'Tasks',
              moreInfo: widget.project.tasks ?? [],
              isExpanded: _isExpanded,
            ),
            SizedBox(height: AppDimensions.paddingS),
            _buildSeeMoreButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSeeMoreButton() {
    final hasExpandableContent = (widget.project.techUsed?.length ?? 0) > 3 ||
        (widget.project.dependencies?.length ?? 0) > 3 ||
        (widget.project.tasks?.length ?? 0) > 3;

    if (!hasExpandableContent) {
      return const SizedBox.shrink();
    }

    return Center(
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 3.14159,
            child: TextButton(
              onPressed: _toggleExpanded,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                    size: AppDimensions.iconM,
                  ),
                  SizedBox(width: AppDimensions.paddingS),
                  Flexible(
                    child: Text(
                      _isExpanded ? "See Less" : "See More",
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
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
    this.isExpanded = false,
  }) : super(key: key);

  final String title;
  final List<String> moreInfo;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    if (moreInfo.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayItems = isExpanded ? moreInfo : moreInfo.take(3).toList();
    final hasMoreItems = moreInfo.length > 3;

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
              children: [
                ...displayItems
                    .map((item) => Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: AutoSizeText(
                            "• $item",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            minFontSize: 9,
                            maxLines: isExpanded ? null : 2,
                            overflow: isExpanded ? null : TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                if (!isExpanded && hasMoreItems)
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      "... and ${moreInfo.length - 3} more",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary.withOpacity(0.7),
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                      ),
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
