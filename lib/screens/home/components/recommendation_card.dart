import 'package:flutter/material.dart';
import 'package:my_profile/models/more_info.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_text_styles.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    Key? key,
    required this.moreInfo,
  }) : super(key: key);

  final MoreInfo moreInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1000,
      height: 300,
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
              moreInfo.infoType ?? '',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppDimensions.paddingS),
            if (moreInfo.details != null && moreInfo.details!.isNotEmpty)
              ...moreInfo.details!.map(
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
            if (moreInfo.details == null || moreInfo.details!.isEmpty)
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
          ],
        ),
      ),
    );
  }
}