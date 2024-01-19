import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/components/animated_counter.dart';
import 'package:my_profile/responsive.dart';
import 'package:my_profile/utils/string_util.dart';

import '../../../constants.dart';
import 'heigh_light.dart';

class HighLightsInfo extends StatelessWidget {
  const HighLightsInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoBloc, MyInfoState>(
      builder: (context, state) {
        final userInfo = state.userInfo;
        final project = state.myProjects;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          child: Responsive.isMobileLarge(context)
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HeighLight(
                          counter: AnimatedCounter(
                            value: userInfo!.exp.formatStringToExp(),
                            text: "+",
                          ),
                          label: "Months EXP",
                        ),
                        const HeighLight(
                          counter: AnimatedCounter(
                            value: 2,
                            text: "",
                          ),
                          label: "Languages",
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HeighLight(
                          counter: AnimatedCounter(
                            value: project.length,
                            text: "+",
                          ),
                          label: "Projects",
                        ),
                        const HeighLight(
                          counter: AnimatedCounter(
                            value: 2,
                            text: "",
                          ),
                          label: "Languages Code",
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeighLight(
                      counter: AnimatedCounter(
                        value: userInfo!.exp.formatStringToExp(),
                        text: "+",
                      ),
                      label: "Months EXP",
                    ),
                    const HeighLight(
                      counter: AnimatedCounter(
                        value: 2,
                        text: "",
                      ),
                      label: "Languages",
                    ),
                    HeighLight(
                      counter: AnimatedCounter(
                        value: project.length,
                        text: "+",
                      ),
                      label: "Projects",
                    ),
                    const HeighLight(
                      counter: AnimatedCounter(
                        value: 2,
                        text: "",
                      ),
                      label: "Languages Code",
                    ),
                  ],
                ),
        );
      },
    );
  }
}
