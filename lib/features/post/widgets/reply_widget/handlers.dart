import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:html/parser.dart';
import 'package:mobichan/core/core.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/localization.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart'; // Replaced share
// import 'package:cross_file/cross_file.dart'; // Removed as XFile is exported by share_plus
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

extension ReplyWidgetHandlers on ReplyWidget {
  void handleTapImage({
    required BuildContext context,
    required Board board,
    required List<Post> imagePosts,
    required int imageIndex,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => CarouselPage(
          board: board,
          posts: imagePosts,
          imageIndex: imageIndex,
          heroTitle: "image$imageIndex",
        ),
      ),
    );
  }

  void handleTapUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  void handleTapReplies(BuildContext context, Post post) {
    final postReplies = post.getReplies(threadReplies);
    if (!inDialog) {
      showDialog(
        context: context,
        builder: (context) => RepliesPage(
          board: board,
          replyingTo: post,
          postReplies: postReplies,
          threadReplies: threadReplies,
        ),
      );
    } else {
      context.read<RepliesDialogCubit>().setReplies(postReplies, post);
    }
  }

  void handleTapQuotelink(BuildContext context, String quotelink) {
    Post? quotedPost = threadReplies.getQuotedPost(quotelink);
    if (quotedPost == null) return;

    if (!inDialog) {
      showDialog(
        context: context,
        builder: (context) => RepliesPage(
          board: board,
          postReplies: [quotedPost],
          threadReplies: threadReplies,
        ),
      );
    } else {
      context.read<RepliesDialogCubit>().setReplies([quotedPost], null);
    }
  }

  void handleQuote(BuildContext context, int start, int end) {
    final html = insertATags(
      post.com!.replaceAll(RegExp(r'\>\s+\<'), '><').replaceAll('<br>', '\n'),
    );
    final document = parse(html);
    final String parsedString = parse(
      document.body!.text,
    ).documentElement!.text.unescapeHtml;

    final String quote = parsedString.substring(start, end);
    context.read<PostFormCubit>().quote(quote, post);
  }

  void handleReply(BuildContext context, Post reply) {
    context.read<PostFormCubit>().reply(reply);
  }

  void handleReport() async {
    final url =
        'https://sys.4channel.org/${board.board}/imgboard.php?mode=report&no=${post.no}';
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
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(errorSnackbar(context, kSavePostError.tr()));
        return;
      }
      final image = await screenshotController.capture();
      await Gal.putImageBytes(
        image!,
        name: "post_${post.no}",
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(successSnackbar(context, kSavePostSuccess.tr()));
    } on GalException catch (e) {
      log(e.type.message);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(errorSnackbar(context, kSavePostError.tr()));
    }
  }

  void handleShare() async {
    try {
      final image = await screenshotController.capture();
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = await File('${directory.path}/post_${post.no}.png').create();
        await imagePath.writeAsBytes(image);

        // Share with both the screenshot and the post URL
        final postUrl = 'https://boards.4channel.org/${board.board}/thread/${post.resto}#p${post.no}';
        // ignore: deprecated_member_use
        await Share.shareXFiles(
          [XFile(imagePath.path)],
          text: 'Mobichan post: $postUrl',
        );
      }
    } catch (e) {
      log('Error sharing post: $e');
    }
  }
}
