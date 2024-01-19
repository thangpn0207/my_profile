import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/components/animated_progress_indicator.dart';

import '../../../constants.dart';

class Coding extends StatelessWidget {
  const Coding({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoBloc, MyInfoState>(
      builder: (context, state) {
        final coding = state.userInfo?.coding;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: Text(
                "Coding",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Row(
              children: coding
                      ?.map((e) => Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: AnimatedCircularProgressIndicator(
                                percentage: e.percent ?? 0,
                                label: e.name ?? '',
                              ),
                            ),
                          ))
                      .toList() ??
                  [],
            ),
            // const Row(
            //   children: [
            //     Expanded(
            //       child: AnimatedCircularProgressIndicator(
            //         percentage: 0.7,
            //         label: "Flutter",
            //       ),
            //     ),
            //     SizedBox(width: defaultPadding),
            //     Expanded(
            //       child: AnimatedCircularProgressIndicator(
            //         percentage: 0.8,
            //         label: "Dart",
            //       ),
            //     ),
            //     SizedBox(width: defaultPadding),
            //     Expanded(
            //       child: AnimatedCircularProgressIndicator(
            //         percentage: 0.55,
            //         label: "Firebase",
            //       ),
            //     ),
            //   ],
            // ),
          ],
        );
      },
    );
  }
}
