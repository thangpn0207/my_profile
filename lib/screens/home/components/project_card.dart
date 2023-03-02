import 'package:flutter/material.dart';
import 'package:my_profile/models/Project.dart';
import 'package:my_profile/responsive.dart';

import '../../../constants.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    Key? key,
    required this.project,
  }) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      color: secondaryColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Colors.amber),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              project.description!,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(height: 1.5),
            ),
            // TextButton(
            //   onPressed: () {},
            //   child: const Text(
            //     "Read More >>",
            //     style: TextStyle(color: primaryColor),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
