import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/components/animated_progress_indicator.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class CodingWidget extends StatelessWidget {
  const CodingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoBloc, MyInfoState>(
      builder: (context, state) {
        final coding = state.userInfo?.coding;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: AppColors.glowBorder, thickness: 1),
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
              child: Text(
                "ENGINEERING_SKILLS",
                style: GoogleFonts.shareTechMono(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            if (coding != null && coding.isNotEmpty)
              ...coding.map((e) => AnimatedLinearProgressIndicator(
                    percentage: (e.percent ?? 0),
                    label: e.name ?? '',
                  ))
            else
              Text(
                'ERROR: NO_SKILLS_FOUND',
                style: GoogleFonts.shareTechMono(
                  color: AppColors.error,
                  fontSize: 12,
                ),
              ),
          ],
        );
      },
    );
  }
}
