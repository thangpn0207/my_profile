import 'package:flutter/material.dart';

import '../../../core/app_dimensions.dart';
import '../../../core/app_text_styles.dart';

class HighLight extends StatelessWidget {
  const HighLight({
    super.key,
    required this.counter,
    this.label,
  });

  final Widget counter;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        counter,
        SizedBox(height: AppDimensions.paddingS),
        if (label != null)
          Text(
            label!,
            style: AppTextStyles.titleSmall,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}