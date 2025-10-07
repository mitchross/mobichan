import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:shimmer/shimmer.dart';

import 'image_widget.dart';

extension ImageWidgetBuilders on ImageWidgetState {
  Widget buildLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade700,
      highlightColor: Colors.grey.shade600,
      child: Container(color: Colors.white),
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
          placeholder: (context, url) {
            return Image.network(
              widget.post.getThumbnailUrl(widget.board) ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback for missing thumbnail
                return Container(
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          color: Colors.white,
                          size: 40,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No preview available',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
              loadingBuilder: (context, widget, progress) {
                return buildLoading();
              },
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
