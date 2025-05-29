import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_text_styles.dart';
import 'recommendation_card.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1200,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ABOUT ME",
              style: AppTextStyles.headlineMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            SizedBox(height: AppDimensions.paddingM),
            BlocBuilder<MyInfoBloc, MyInfoState>(
              builder: (context, state) {
                if (state.moreInfos.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingXL),
                      child: Text(
                        'No information available',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      state.moreInfos.length,
                          (index) => Padding(
                        padding: EdgeInsets.only(right: AppDimensions.paddingM),
                        child: RecommendationCard(
                          moreInfo: state.moreInfos[index],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}