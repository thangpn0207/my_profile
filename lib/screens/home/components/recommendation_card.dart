import 'package:flutter/material.dart';
import 'package:my_profile/models/more_info.dart';

import '../../../constants.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    Key? key,
    required this.moreInfo,
  }) : super(key: key);

  final MoreInfo moreInfo;

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
              moreInfo.infoType ?? '',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Colors.amber),
            ),
            ...?moreInfo.details
                ?.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text('-- $e'),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
