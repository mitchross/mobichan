import 'package:flutter/material.dart';
import 'package:mobichan/features/post/post.dart';
import 'package:mobichan/features/post/widgets/video_thumbnail_widget.dart';
import 'package:mobichan_domain/mobichan_domain.dart';

class ThumbnailWidget extends StatefulWidget {
  final Board board;
  final Post post;
  final double height;
  final double borderRadius;
  final bool fullRes;

  const ThumbnailWidget({
    super.key,
    required this.board,
    required this.post,
    required this.height,
    this.borderRadius = 0,
    this.fullRes = false,
  });

  @override
  State<ThumbnailWidget> createState() => ThumbnailWidgetState();
}

class ThumbnailWidgetState extends State<ThumbnailWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        height: widget.height,
        child: widget.post.isVideo
            ? VideoThumbnailWidget(
                board: widget.board,
                post: widget.post,
              )
            : ImageWidget(
                board: widget.board,
                post: widget.post,
                fullRes: widget.fullRes,
              ),
      ),
    );
  }
}
