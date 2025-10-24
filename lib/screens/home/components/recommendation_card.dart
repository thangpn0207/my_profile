import 'package:flutter/material.dart';
import 'package:my_profile/models/more_info.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_text_styles.dart';

class RecommendationCard extends StatefulWidget {
  const RecommendationCard({
    Key? key,
    required this.moreInfo,
  }) : super(key: key);

  final MoreInfo moreInfo;

  @override
  State<RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<RecommendationCard>
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
    final details = widget.moreInfo.details ?? [];
    final hasExpandableContent = details.length > 3;
    final displayDetails = _isExpanded ? details : details.take(3).toList();

    return Container(
      width: 1000,
      height: _isExpanded ? null : 300,
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
            Text(
              widget.moreInfo.infoType ?? '',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppDimensions.paddingS),
            if (displayDetails.isNotEmpty)
              ...displayDetails.map(
                (detail) => Padding(
                  padding: EdgeInsets.only(bottom: AppDimensions.paddingXS),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          detail,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (!_isExpanded && hasExpandableContent)
              Padding(
                padding: EdgeInsets.only(top: AppDimensions.paddingXS),
                child: Text(
                  "... and ${details.length - 3} more details",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            if (details.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: AppDimensions.paddingS),
                child: Text(
                  'No additional information available.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            if (hasExpandableContent) ...[
              SizedBox(height: AppDimensions.paddingS),
              _buildSeeMoreButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSeeMoreButton() {
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
