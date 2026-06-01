import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:my_profile/bloc/my_info_bloc.dart';
import 'package:my_profile/core/app_colors.dart';
import 'package:my_profile/models/user_info.dart';
import 'package:my_profile/utils/string_util.dart';
import 'package:url_launcher/url_launcher.dart';

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
      backgroundColor: Colors.transparent, // Let the main container handle the color/glass effect
      elevation: 0,
      child: BlocBuilder<MyInfoBloc, MyInfoState>(
        builder: (context, state) {
          final userInfo = state.userInfo;
          return Column(
            children: [
              const MyInfo(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildSectionTitle("GEOGRAPHIC_DATA"),
                      AreaInfoText(title: "Country", text: userInfo?.country ?? ""),
                      AreaInfoText(title: "City", text: userInfo?.city ?? ""),
                      AreaInfoText(title: "DOB", text: userInfo?.dob.formatStringToDOB()),
                      const SizedBox(height: 20),
                      _buildSectionTitle("EDUCATION_LOG"),
                      AreaInfoText(
                        title: userInfo?.university ?? 'UNIVERSITY',
                        text: userInfo?.universityRank ?? '',
                      ),
                      const SizedBox(height: 20),
                      const CodingWidget(),
                      const SizedBox(height: 20),
                      const MySkills(),
                      const SizedBox(height: 20),
                      const KnowledgesWidget(),
                      const SizedBox(height: 30),
                      Divider(color: AppColors.primary.withValues(alpha: 0.1), thickness: 1),
                      const SizedBox(height: 10),
                      _buildDownloadButton(context, userInfo?.cvURL ?? ''),
                      const SizedBox(height: 20),
                      _buildSocialMediaSection(context, userInfo),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(width: 4, height: 4, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.shareTechMono(
              color: AppColors.textSecondary,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context, String cvUrl) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextButton(
        onPressed: () => cvUrl.isNotEmpty ? _launchUrl(cvUrl) : null,
        style: TextButton.styleFrom(padding: const EdgeInsets.all(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "MY_CV.PDF",
              style: GoogleFonts.shareTechMono(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.download, color: AppColors.primary, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection(BuildContext context, UserInfo? userInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon(
          onPressed: () => _launchUrl(userInfo?.linkinURL ?? ''),
          icon: SvgPicture.asset(
            "assets/icons/linkedin.svg",
            width: 20,
            colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
          ),
        ),
        _buildSocialIcon(
          onPressed: () => _launchUrl(userInfo?.facebookURL ?? ''),
          icon: LineIcon.facebookSquare(color: AppColors.textSecondary, size: 24),
        ),
        _buildSocialIcon(
          onPressed: () => _launchUrl("mailto:${userInfo?.mailto ?? ''}"),
          icon: const Icon(Icons.email_outlined, color: AppColors.textSecondary, size: 22),
        ),
        _buildSocialIcon(
          onPressed: () => _launchUrl(userInfo?.githubURL ?? ""),
          icon: SvgPicture.asset(
            "assets/icons/github.svg",
            width: 20,
            colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon({required VoidCallback onPressed, required Widget icon}) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      hoverColor: AppColors.primary.withValues(alpha: 0.1),
      splashRadius: 20,
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      if (url.isEmpty) return;

      Uri uri;
      if (!url.startsWith('http') && !url.startsWith('mailto') && !url.startsWith('tel')) {
        // Resolve relative paths dynamically on the web against the host's base URL (Uri.base)
        final String basePath = Uri.base.toString();
        final String cleanedBase = basePath.split('?').first.split('#').first;
        if (cleanedBase.endsWith('/')) {
          uri = Uri.parse('$cleanedBase$url');
        } else {
          uri = Uri.parse('$cleanedBase/$url');
        }
      } else {
        uri = Uri.parse(url);
      }

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $uri');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
