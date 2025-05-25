import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
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
    final image = await screenshotController.capture();
    final result = await ImageGallerySaver.saveImage(
      image!,
      name: "post_${thread.no}",
      quality: 60,
    );
    if (result['isSuccess'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        successSnackbar(context, kSavePostSuccess.tr()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackbar(context, kSavePostError.tr()),
      );
    }
  }

  void handleShare() async {
    await SharePlus.share( // Added await, Replaced Share.share
      'https://boards.4channel.org/${board.board}/thread/${thread.no}',
    );
  }
}
