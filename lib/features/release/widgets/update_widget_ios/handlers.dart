import 'package:flutter/material.dart';
import 'package:mobichan/features/release/release.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:url_launcher/url_launcher.dart';

extension UpdateWidgetIosHandlers on UpdateWidgetIos {
  handleLaterPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  handleGoToReleasePage(Release release) async {
    if (release.ipaUrl == null) return;
    final url = release.ipaUrl!;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url)); // Defaults to LaunchMode.platformDefault
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
