import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_text_styles.dart';

class HighLight extends StatefulWidget {
  const HighLight({
    super.key,
    required this.counter,
    this.label,
  });

  final Widget counter;
  final String? label;

  @override
  State<HighLight> createState() => _HighLightState();
}

class _HighLightState extends State<HighLight> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: AppDimensions.animationFast),
        padding: EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.surface.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: _isHovered
              ? Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.counter,
            SizedBox(height: AppDimensions.paddingS),
            if (widget.label != null)
              Text(
                widget.label!,
                style: AppTextStyles.titleSmall.copyWith(
                  color:
                      _isHovered ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
