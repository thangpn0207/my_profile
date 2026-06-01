import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_profile/models/more_info.dart';

import '../../../core/app_colors.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.moreInfo,
  });

  final MoreInfo moreInfo;

  @override
  Widget build(BuildContext context) {
    final details = moreInfo.details ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "// ${moreInfo.infoType?.toUpperCase() ?? 'SYSTEM_LOG'}",
            style: GoogleFonts.shareTechMono(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...details.map((detail) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "> ",
                      style: GoogleFonts.shareTechMono(
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        detail,
                        style: GoogleFonts.shareTechMono(
                          color: AppColors.textPrimary.withValues(alpha: 0.9),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms * details.indexOf(detail))),
        ],
      ),
    );
  }
}
