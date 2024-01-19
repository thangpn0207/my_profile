import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class AreaInfoText extends StatelessWidget {
  const AreaInfoText({
    Key? key,
    this.title,
    this.text,
  }) : super(key: key);

  final String? title, text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding / 2),
      child: Row(
        children: [
          Expanded(
            child: AutoSizeText(
              title!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          AutoSizeText(text!),
        ],
      ),
    );
  }
}
