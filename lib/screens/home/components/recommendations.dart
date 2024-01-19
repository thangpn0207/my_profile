import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';

import '../../../constants.dart';
import 'recommendation_card.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ABOUT ME",
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 24),
          ),
          const SizedBox(height: defaultPadding),
          BlocBuilder<MyInfoBloc, MyInfoState>(
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    state.moreInfos.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: defaultPadding),
                      child: RecommendationCard(
                        moreInfo: state.moreInfos[index],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
