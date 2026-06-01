import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class MyInfo extends StatelessWidget {
  const MyInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Technical Logo / System Icon
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: const Center(
                  child: Icon(Icons.psychology, color: AppColors.primary, size: 24),
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "LOGGED_AGENT",
                    style: GoogleFonts.shareTechMono(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    "THANG_PN.DEV",
                    style: GoogleFonts.shareTechMono(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // System Metrics / Status
          _buildStatusRow("OS_VERSION", "FLUTTER_3.27.0"),
          const SizedBox(height: 8),
          _buildStatusRow("CORE_LOAD", "STABLE"),
          const SizedBox(height: 8),
          _buildStatusRow("NETWORK", "ENCRYPTED"),

          const SizedBox(height: 16),

          // Live Ping simulation
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1.seconds),
              const SizedBox(width: 8),
              Text(
                "SYSTEM_ACTIVE // 24ms",
                style: GoogleFonts.shareTechMono(
                  fontSize: 10,
                  color: AppColors.success.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "> $label:",
          style: GoogleFonts.shareTechMono(fontSize: 10, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: GoogleFonts.shareTechMono(
              fontSize: 10, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
