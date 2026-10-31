import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens bundled-data links; relative paths (e.g. the CV asset) resolve against the page.
Future<void> openUrl(String url) async {
  if (url.isEmpty) return;
  try {
    await launchUrl(Uri.base.resolve(url),
        mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint('openUrl failed: $e');
  }
}
