import 'package:flutter/material.dart';
import 'package:my_profile/models/Recommendation.dart';

import '../../../constants.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    Key? key,
    required this.recommendation,
  }) : super(key: key);

  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 300,
      padding: const EdgeInsets.all(defaultPadding),
      color: secondaryColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recommendation.name!,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Colors.amber),
            ),
            Text(recommendation.source!),
            const SizedBox(height: defaultPadding),
            Text(
              recommendation.text!,
              style: const TextStyle(height: 1.5),
            )
          ],
        ),
      ),
    );
  }
}
