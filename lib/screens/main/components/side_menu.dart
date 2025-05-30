import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icon.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/utils/string_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_text_styles.dart';
import '../../../models/user_info.dart';
import 'area_info_text.dart';
import 'coding.dart';
import 'knowledges.dart';
import 'my_info.dart';
import 'skills.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: BlocBuilder<MyInfoBloc, MyInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return SafeArea(
            child: Column(
              children: [
                const MyInfo(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(AppDimensions.paddingS),
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
                          text: userInfo?.dob.formatStringToDOB(),
                        ),
                        AreaInfoText(
                          title: userInfo?.university ?? '',
                          text: userInfo?.universityRank ?? '',
                        ),
                        const CodingWidget(),
                        SizedBox(height: AppDimensions.paddingM),
                        const MySkills(),
                        const KnowledgesWidget(),
                        Divider(
                          color: AppColors.divider,
                          thickness: 1,
                        ),
                        SizedBox(height: AppDimensions.paddingS),
                        _buildDownloadButton(context, userInfo?.cvURL ?? ''),
                        _buildSocialMediaSection(context, userInfo),
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

  Widget _buildDownloadButton(BuildContext context, String cvUrl) {
    return TextButton(
      onPressed: () {
        if (cvUrl.isNotEmpty) {
          _launchUrl(cvUrl);
        }
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
      ),
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "DOWNLOAD CV",
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(width: AppDimensions.paddingS),
            SvgPicture.asset(
              "assets/icons/download.svg",
              width: AppDimensions.iconS,
              height: AppDimensions.iconS,
              colorFilter: ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection(BuildContext context, UserInfo? userInfo) {
    return Container(
      margin: EdgeInsets.only(top: AppDimensions.paddingM),
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSocialButton(
            onPressed: () => _launchUrl(userInfo?.linkinURL ?? ''),
            icon: SvgPicture.asset(
              "assets/icons/linkedin.svg",
              width: AppDimensions.iconM,
              height: AppDimensions.iconM,
              colorFilter: ColorFilter.mode(
                AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            tooltip: 'LinkedIn',
          ),
          _buildSocialButton(
            onPressed: () => _launchUrl(userInfo?.facebookURL ?? ''),
            icon: LineIcon.facebookSquare(
              color: AppColors.textSecondary,
              size: AppDimensions.iconM,
            ),
            tooltip: 'Facebook',
          ),
          _buildSocialButton(
            onPressed: () => _launchUrl("mailto:${userInfo?.mailto ?? ''}"),
            icon: Icon(
              Icons.email_outlined,
              color: AppColors.textSecondary,
              size: AppDimensions.iconM,
            ),
            tooltip: 'Email',
          ),
          _buildSocialButton(
            onPressed: () => _launchUrl(userInfo?.githubURL ?? ""),
            icon: SvgPicture.asset(
              "assets/icons/github.svg",
              width: AppDimensions.iconM,
              height: AppDimensions.iconM,
              colorFilter: ColorFilter.mode(
                AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            tooltip: 'GitHub',
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required Widget icon,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        splashRadius: AppDimensions.iconM,
        padding: EdgeInsets.all(AppDimensions.paddingS),
      ),
    );
  }
}

Future<void> downloadFile(String urlStr) async {
  try {
    if (urlStr.isEmpty) return;
  } catch (e) {
    // Handle error silently or show user feedback
    print('Error downloading file: $e');
  }
}

Future<void> _launchUrl(String url) async {
  try {
    if (url.isEmpty) return;
    final Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  } catch (e) {
    // Handle error silently or show user feedback
    print('Error launching URL: $e');
  }
}
