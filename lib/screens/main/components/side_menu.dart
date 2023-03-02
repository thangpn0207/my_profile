import 'dart:html' as html;
import 'dart:html';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icon.dart';
import 'package:my_profile/constants.dart';
import 'package:url_launcher/url_launcher.dart';

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
      child: SafeArea(
        child: Column(
          children: [
            const MyInfo(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    const AreaInfoText(
                      title: "Residence",
                      text: "Viet Nam",
                    ),
                    const AreaInfoText(
                      title: "City",
                      text: "Ha Noi",
                    ),
                    const AreaInfoText(
                      title: "Age",
                      text: "23",
                    ),
                    const AreaInfoText(
                      title: "Greenwich University",
                      text: "First class",
                    ),
                    const Coding(),
                    const SizedBox(height: defaultPadding),
                    const MySkills(),
                    const Knowledges(),
                    const Divider(),
                    const SizedBox(height: defaultPadding / 2),
                    TextButton(
                      onPressed: () {
                        downloadFile();
                      },
                      child: FittedBox(
                        child: Row(
                          children: [
                            Text(
                              "DOWNLOAD CV",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
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
                              _launchUrl(
                                  'https://www.linkedin.com/in/th%E1%BA%AFng-ph%E1%BA%A1m-4ba88720a/');
                            },
                            icon: SvgPicture.asset("assets/icons/linkedin.svg"),
                          ),
                          IconButton(
                            onPressed: () async {
                              _launchUrl('https://www.facebook.com/thangpn272');
                            },
                            icon: LineIcon.facebookSquare(
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _launchUrl("mailto:thangpn0207@gmail.com");
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
      ),
    );
  }
}

downloadFile() async {
  final url = await FirebaseStorage.instance
      .refFromURL("gs://phamngocthanginfo.appspot.com/Pham-Ngoc-Thang.pdf")
      .getDownloadURL();
  final anchor = AnchorElement(href: url)
    ..download = 'Pham-Ngoc-Thang-Flutter-CV.pdf';
  document.body?.append(anchor);
  anchor.click();
}

Future<void> _launchUrl(String url) async {
  html.window.open(url, '_blank');
}
