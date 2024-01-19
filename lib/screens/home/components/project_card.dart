import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_profile/models/my_project.dart';

import '../../../constants.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    Key? key,
    required this.project,
  }) : super(key: key);

  final MyProject project;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      color: secondaryColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ItemTitle(
              title: project.name ?? '',
              time: '${project.startTime}-${project.endTime}',
            ),
            const SizedBox(
              height: 10,
            ),
            _ItemInfo(
              title: 'Company',
              info: project.company ?? "",
            ),
            _ItemInfo(
              title: 'Role',
              info: project.role ?? "",
            ),
            _ItemInfoList(
              title: 'Tech used',
              moreInfo: project.techUsed ?? [],
            ),
            _ItemInfoList(
              title: 'Dependencies',
              moreInfo: project.dependencies ?? [],
            ),
            _ItemInfoList(
              title: 'Tasks',
              moreInfo: project.tasks ?? [],
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

class _ItemTitle extends StatelessWidget {
  const _ItemTitle({required this.title, required this.time});
  final String title;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AutoSizeText(
            title,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Colors.amber),
          ),
        ),
        Text(
          time,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.amber),
        )
      ],
    );
  }
}

class _ItemInfo extends StatelessWidget {
  const _ItemInfo({required this.title, required this.info});
  final String title;
  final String info;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "◦ $title: ",
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Colors.white),
        ),
        Expanded(
          child: Text(
            info,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white),
          ),
        )
      ],
    );
  }
}

class _ItemInfoList extends StatelessWidget {
  const _ItemInfoList({required this.title, required this.moreInfo});
  final String title;
  final List<String> moreInfo;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "◦ $title: ",
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Colors.white),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: moreInfo
                .map((e) => Text(
                      "* $e",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
