
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:shimmer/shimmer.dart';

class VideoThumbnailWidget extends StatelessWidget {
  final Board board;
  final Post post;

  const VideoThumbnailWidget({
    super.key,
    required this.board,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: post.getThumbnailUrl(board)!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey.shade700,
            highlightColor: Colors.grey.shade600,
            child: Container(
              color: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        const Center(
          child: Icon(
            Icons.play_circle_outline,
            color: Colors.white,
            size: 60,
          ),
        ),
      ],
    );
  }
}
