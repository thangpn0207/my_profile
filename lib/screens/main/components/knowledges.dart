import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';

import '../../../constants.dart';

class Knowledges extends StatelessWidget {
  const Knowledges({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoBloc, MyInfoState>(
      builder: (context, state) {
        final knowledges = state.userInfo?.knowledge;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: Text(
                "Knowledges",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            ...?knowledges
                ?.map((e) => KnowledgeText(
                      text: e.name ?? '',
                    ))
                .toList()
            // const KnowledgeText(text: "Flutter, Dart"),
            // const KnowledgeText(text: "GIT flow"),
            // const KnowledgeText(text: "Agile,Scrum"),
            // const KnowledgeText(text: "Upload app to store"),
          ],
        );
      },
    );
  }
}

class KnowledgeText extends StatelessWidget {
  const KnowledgeText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding / 2),
      child: Row(
        children: [
          SvgPicture.asset("assets/icons/check.svg"),
          const SizedBox(width: defaultPadding / 2),
          Expanded(
            child: AutoSizeText(
              text,
              minFontSize: 4,
            ),
          ),
        ],
      ),
    );
  }
}
