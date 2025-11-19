import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gal/gal.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/localization.dart';
import 'package:share_plus/share_plus.dart'; // Replaced share
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

import 'thread_widget.dart';

extension ThreadWidgetHandlers on ThreadWidget {
  void handleReply(BuildContext context) {
    context.read<PostFormCubit>().reply(thread);
  }

  void handleReport() async {
    final url =
        'https://sys.4channel.org/${board.board}/imgboard.php?mode=report&no=${thread.no}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  void handleSave(BuildContext context) async {
    try {
      final hasAccess = await Gal.requestAccess();
      if (!hasAccess) {
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackbar(context, kSavePostError.tr()));
        return;
      }
      final image = await screenshotController.capture();
      await Gal.putImageBytes(
        image!,
        name: "post_${thread.no}",
        album: "Mobichan",
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(successSnackbar(context, kSavePostSuccess.tr()));
    } on GalException catch (e) {
      log(e.type.message);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(errorSnackbar(context, kSavePostError.tr()));
    }
  }

  void handleShare() async {
    try {
      final threadUrl = 'https://boards.4channel.org/${board.board}/thread/${thread.no}';
      await Share.share(
        threadUrl,
        subject: thread.sub ?? 'Thread from Mobichan',
      );
    } catch (e) {
      log('Error sharing thread: $e');
    }
  }
}
