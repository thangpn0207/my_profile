import 'package:flutter/material.dart';
import 'package:my_profile/components/animated_counter.dart';
import 'package:my_profile/responsive.dart';

import '../../../constants.dart';
import 'heigh_light.dart';

class HighLightsInfo extends StatelessWidget {
  const HighLightsInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: Responsive.isMobileLarge(context)
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    HeighLight(
                      counter: AnimatedCounter(
                        value: 24,
                        text: "+",
                      ),
                      label: "Months EXP",
                    ),
                    HeighLight(
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
                  children: const [
                    HeighLight(
                      counter: AnimatedCounter(
                        value: 6,
                        text: "+",
                      ),
                      label: "Projects",
                    ),
                    HeighLight(
                      counter: AnimatedCounter(
                        value: 2,
                        text: "",
                      ),
                      label: "Tech company",
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                HeighLight(
                  counter: AnimatedCounter(
                    value: 24,
                    text: "+",
                  ),
                  label: "Months EXP",
                ),
                HeighLight(
                  counter: AnimatedCounter(
                    value: 2,
                    text: "",
                  ),
                  label: "Languages",
                ),
                HeighLight(
                  counter: AnimatedCounter(
                    value: 6,
                    text: "+",
                  ),
                  label: "Projects",
                ),
                HeighLight(
                  counter: AnimatedCounter(
                    value: 2,
                    text: "",
                  ),
                  label: "Tech Company",
                ),
              ],
            ),
    );
  }
}
