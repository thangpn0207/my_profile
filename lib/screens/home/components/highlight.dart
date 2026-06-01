import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class HighLight extends StatefulWidget {
  const HighLight({
    super.key,
    required this.counter,
    this.label,
    this.onTap,
  });

  final Widget counter;
  final String? label;
  final VoidCallback? onTap;

  @override
  State<HighLight> createState() => _HighLightState();
}

class _HighLightState extends State<HighLight> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DefaultTextStyle(
                style: GoogleFonts.shareTechMono(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                child: widget.counter,
              ),
              const SizedBox(height: 8),
              if (widget.label != null)
                Text(
                  widget.label!.toUpperCase(),
                  style: GoogleFonts.shareTechMono(
                    color: _isHovered ? AppColors.primary : AppColors.textSecondary,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
