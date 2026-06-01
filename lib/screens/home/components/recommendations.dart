import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import 'recommendation_card.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({
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
                Icons.terminal,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                "CORE_IDENTITY",
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
        BlocBuilder<MyInfoBloc, MyInfoState>(
          builder: (context, state) {
            if (state.moreInfos.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              children: state.moreInfos
                  .map((info) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: RecommendationCard(moreInfo: info),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
