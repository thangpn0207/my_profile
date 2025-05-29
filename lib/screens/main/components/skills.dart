import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/components/animated_progress_indicator.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_text_styles.dart';

class MySkills extends StatelessWidget {
  const MySkills({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoBloc, MyInfoState>(
      builder: (context, state) {
        final skills = state.userInfo?.skills;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: AppColors.divider,
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
              child: Text(
                "Skills",
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (skills != null && skills.isNotEmpty)
              ...skills
                  .map((e) => AnimatedLinearProgressIndicator(
                percentage: (e.percent ?? 0), // Convert to 0-1 range
                label: e.name ?? "",
              ))

            else
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
                child: Text(
                  'No skills available',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}