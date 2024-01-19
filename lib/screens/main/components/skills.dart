import 'package:flutter/material.dart';

import 'package:my_profile/components/animated_progress_indicator.dart';

import '../../../constants.dart';

class MySkills extends StatelessWidget {
  const MySkills({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          child: Text(
            "Skill",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const AnimatedLinearProgressIndicator(
          percentage: 0.7,
          label: "GIT",
        ),
        const AnimatedLinearProgressIndicator(
          percentage: 0.5,
          label: "ENGLISH",
        ),
        const AnimatedLinearProgressIndicator(
          percentage: 0.8,
          label: "COMMUNICATE",
        ),
        const AnimatedLinearProgressIndicator(
          percentage: 0.7,
          label: "PROBLEM SOLVING",
        ),
        const AnimatedLinearProgressIndicator(
          percentage: 0.7,
          label: "CRITICAL THINKING",
        ),
        const AnimatedLinearProgressIndicator(
          percentage: 0.9,
          label: "TEAM WORK",
        ),
        const AnimatedLinearProgressIndicator(
          percentage: 0.8,
          label: "READING DOCUMENT",
        ),
        const AnimatedLinearProgressIndicator(
          percentage: 0.7,
          label: "KNOWLEDGE ABOUT SOURCETREE",
        ),
        const AnimatedLinearProgressIndicator(
          percentage: 0.5,
          label: "KNOWLEDGE ABOUT POSTMAN",
        ),
      ],
    );
  }
}
