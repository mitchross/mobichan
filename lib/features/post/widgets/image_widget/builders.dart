import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:shimmer/shimmer.dart';

import 'package:mobichan/constants.dart';
import 'image_widget.dart';

extension ImageWidgetBuilders on ImageWidgetState {
  Widget buildLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade700,
      highlightColor: Colors.grey.shade600,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget buildImage(String imageUrl, List<Setting> settings) {
    bool crop = settings.findByTitle('center_crop_image')?.value as bool;

    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          fit: crop ? BoxFit.fitHeight : BoxFit.cover,
          imageUrl: imageUrl,
          httpHeaders: const {'User-Agent': userAgent},
          placeholder: (context, url) => buildLoading(),
          errorWidget: (context, url, error) {
            // If main image fails, try loading thumbnail
            if (url != widget.post.getThumbnailUrl(widget.board)) {
              return CachedNetworkImage(
                imageUrl: widget.post.getThumbnailUrl(widget.board)!,
                httpHeaders: const {'User-Agent': userAgent},
                fit: BoxFit.cover,
                placeholder: (context, url) => buildLoading(),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.white54,
                      size: 48,
                    ),
                  ),
                ),
              );
            }
            return Container(
              color: Colors.grey.shade800,
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.white54,
                  size: 48,
                ),
              ),
            );
          },
          fadeInDuration: Duration.zero,
        ),
        if (widget.post.isVideo)
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
