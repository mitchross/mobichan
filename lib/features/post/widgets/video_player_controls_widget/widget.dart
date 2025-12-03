import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayerControlsWidget extends StatelessWidget {
  const VideoPlayerControlsWidget({super.key, required this.controller});

  final VideoController controller;

  static const double _replayButtonIconSize = 100;
  static const Color _iconColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 50),
      reverseDuration: const Duration(milliseconds: 200),
      child: StreamBuilder<bool>(
        stream: controller.player.stream.completed,
        builder: (context, completedSnapshot) {
          final isEnded = completedSnapshot.data ?? false;

          if (isEnded) {
            return Center(
              child: FittedBox(
                child: IconButton(
                  onPressed: _replay,
                  color: _iconColor,
                  iconSize: _replayButtonIconSize,
                  icon: const Icon(Icons.replay),
                ),
              ),
            );
          }

          return StreamBuilder<bool>(
            stream: controller.player.stream.playing,
            builder: (context, playingSnapshot) {
              final isPlaying = playingSnapshot.data ?? false;
              // Also check buffering if possible, but simple play/pause is often enough.
              // media_kit has stream.buffering

              return StreamBuilder<bool>(
                stream: controller.player.stream.buffering,
                builder: (context, bufferingSnapshot) {
                  final isBuffering = bufferingSnapshot.data ?? false;

                  if (isBuffering) {
                     // Optional: show loading indicator or just pause icon if you prefer
                     // But usually tap to pause/play is what we want overlaying everything
                  }

                  if (isPlaying) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _pause,
                      child: const SizedBox.expand(),
                    );
                  } else {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _play,
                      child: const SizedBox.expand(), // Make sure it covers the area
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _play() {
    return controller.player.play();
  }

  Future<void> _replay() async {
    await controller.player.seek(Duration.zero);
    await controller.player.play();
  }

  Future<void> _pause() async {
    await controller.player.pause();
  }
}
