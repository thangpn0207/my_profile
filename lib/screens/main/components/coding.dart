import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/components/animated_progress_indicator.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_text_styles.dart';

class CodingWidget extends StatelessWidget {
  const CodingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoBloc, MyInfoState>(
      builder: (context, state) {
        final coding = state.userInfo?.coding;

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
                "Coding",
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (coding != null && coding.isNotEmpty)
              Row(
                children: coding
                    .map((e) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingS,
                    ),
                    child: AnimatedCircularProgressIndicator(
                      percentage: (e.percent ?? 0),
                      label: e.name ?? '',
                    ),
                  ),
                ))
                    .toList(),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
                child: Text(
                  'No coding skills available',
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