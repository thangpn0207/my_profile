import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class KnowledgesWidget extends StatelessWidget {
  const KnowledgesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoBloc, MyInfoState>(
      builder: (context, state) {
        final knowledges = state.userInfo?.knowledge;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: AppColors.glowBorder, thickness: 1),
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
              child: Text(
                "SYSTEM_KNOWLEDGE",
                style: GoogleFonts.shareTechMono(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            if (knowledges != null && knowledges.isNotEmpty)
              ...knowledges.map((e) => KnowledgeText(
                    text: e.name ?? '',
                  ))
            else
              Text(
                'ERROR: NO_DATA_AVAILABLE',
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

class KnowledgeText extends StatelessWidget {
  const KnowledgeText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.code,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AutoSizeText(
              text.toUpperCase(),
              style: GoogleFonts.shareTechMono(
                color: AppColors.textSecondary,
                fontSize: 12,
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
