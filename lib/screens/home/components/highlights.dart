import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/components/animated_counter.dart';
import 'package:my_profile/utils/string_util.dart';

import '../../../core/app_dimensions.dart';
import 'highlight.dart';

class HighLightsInfo extends StatelessWidget {
  const HighLightsInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoBloc, MyInfoState>(
      builder: (context, state) {
        final userInfo = state.userInfo;
        final project = state.myProjects;

        // Check if data is available
        if (userInfo == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
          child: ResponsiveBreakpoints.of(context).isMobile
              ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: HighLight(
                      counter: AnimatedCounter(
                        value: userInfo.exp.formatStringToExp(),
                        text: "+",
                      ),
                      label: "Months EXP",
                    ),
                  ),
                  SizedBox(width: AppDimensions.paddingM),
                   Expanded(
                    child: HighLight(
                      counter: AnimatedCounter(
                        value: 2,
                        text: "",
                      ),
                      label: "Languages",
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.paddingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: HighLight(
                      counter: AnimatedCounter(
                        value: project.length,
                        text: "+",
                      ),
                      label: "Projects",
                    ),
                  ),
                  SizedBox(width: AppDimensions.paddingM),
                   Expanded(
                    child: HighLight(
                      counter: AnimatedCounter(
                        value: userInfo.coding?.length ??0,
                        text: "",
                      ),
                      label: "Languages Code",
                    ),
                  ),
                ],
              ),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: HighLight(
                  counter: AnimatedCounter(
                    value: userInfo.exp.formatStringToExp(),
                    text: "+",
                  ),
                  label: "Months EXP",
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),
              const Expanded(
                child: HighLight(
                  counter: AnimatedCounter(
                    value: 2,
                    text: "",
                  ),
                  label: "Languages",
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: HighLight(
                  counter: AnimatedCounter(
                    value: project.length,
                    text: "+",
                  ),
                  label: "Projects",
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),
               Expanded(
                child: HighLight(
                  counter: AnimatedCounter(
                    value: userInfo.coding?.length ??0,
                    text: "",
                  ),
                  label: "Languages Code",
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}