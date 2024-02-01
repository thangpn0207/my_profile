import "dart:html" as html;
import "dart:html";

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icon.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/constants.dart';
import 'package:my_profile/utils/string_util.dart';

import 'area_info_text.dart';
import 'skills.dart';
import 'knowledges.dart';
import 'my_info.dart';
import 'coding.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<MyInfoBloc, MyInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return SafeArea(
            child: Column(
              children: [
                const MyInfo(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      children: [
                        AreaInfoText(
                          title: "Country",
                          text: userInfo?.country ?? "",
                        ),
                        AreaInfoText(
                          title: "City",
                          text: userInfo?.city ?? "",
                        ),
                        AreaInfoText(
                            title: "DOB",
                            text: userInfo?.dob.formatStringToDOB()),
                        AreaInfoText(
                          title: userInfo?.university ?? '',
                          text: userInfo?.universityRank ?? '',
                        ),
                        const Coding(),
                        const SizedBox(height: defaultPadding),
                        const MySkills(),
                        const Knowledges(),
                        const Divider(),
                        const SizedBox(height: defaultPadding / 2),
                        TextButton(
                          onPressed: () {
                            //downloadFile(userInfo?.cvURL ?? '');
                            _launchUrl(userInfo?.cvURL ?? '');
                          },
                          child: FittedBox(
                            child: Row(
                              children: [
                                Text(
                                  "DOWNLOAD CV",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color,
                                  ),
                                ),
                                const SizedBox(width: defaultPadding / 2),
                                SvgPicture.asset("assets/icons/download.svg")
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: defaultPadding),
                          color: const Color(0xFF24242E),
                          child: Row(
                            children: [
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  _launchUrl('https://github.com/thangpn0207');
                                },
                                icon:
                                    SvgPicture.asset("assets/icons/github.svg"),
                              ),
                              IconButton(
                                onPressed: () {
                                  _launchUrl(userInfo?.linkinURL ?? '');
                                },
                                icon: SvgPicture.asset(
                                    "assets/icons/linkedin.svg"),
                              ),
                              IconButton(
                                onPressed: () async {
                                  _launchUrl(userInfo?.facebookURL ?? '');
                                },
                                icon: LineIcon.facebookSquare(
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _launchUrl("mailto:${userInfo?.mailto}");
                                },
                                icon: const Icon(
                                  Icons.email_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

downloadFile(String urlStr) async {
  final url =
      await FirebaseStorage.instance.refFromURL(urlStr).getDownloadURL();
  final anchor = AnchorElement(href: url)
    ..download = 'Pham-Ngoc-Thang-Flutter-CV.pdf';
  document.body?.append(anchor);
  anchor.click();
}

Future<void> _launchUrl(String url) async {
  html.window.open(url, '_blank');
}
