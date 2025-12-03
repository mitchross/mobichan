import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:mobichan/constants.dart';
import 'package:mobichan/features/post/widgets/video_player_controls_widget/widget.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoController controller;
  final bool showControls;
  final double aspectRatio;
  final bool isMuted;

  const VideoPlayerWidget({
    super.key,
    required this.controller,
    required this.aspectRatio,
    required this.isMuted,
    this.showControls = true,
  });

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with AutomaticKeepAliveClientMixin {
  static const _playerControlsBgColor = Colors.black87;

  late final Player _player;
  
  //
  final double initSnapshotRightPosition = 10;
  final double initSnapshotBottomPosition = 10;
  OverlayEntry? _overlayEntry;

  //
  double sliderValue = 0.0;
  double volumeValue = 50;
  String position = '';
  String duration = '';
  bool validPosition = false;

  //
  List<double> playbackSpeeds = [0.5, 1.0, 2.0];
  int playbackSpeedIndex = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _player = widget.controller.player;
    // Listen to streams for UI updates
    _player.stream.position.listen((pos) {
      if (!mounted) return;
      setState(() {
        sliderValue = pos.inSeconds.toDouble();
        position = _formatDuration(pos);
      });
    });
    _player.stream.duration.listen((dur) {
      if (!mounted) return;
      setState(() {
        duration = _formatDuration(dur);
        validPosition = dur.inSeconds > 0;
      });
    });
    
    checkMuted();
  }

  String _formatDuration(Duration d) {
    var str = d.toString().split('.')[0];
    if (d.inHours == 0) {
      return "${str.split(':')[1]}:${str.split(':')[2]}";
    }
    return str;
  }

  void checkMuted() {
    if (widget.isMuted) {
      _setSoundVolume(0.0);
    } else {
      _setSoundVolume(50.0); // Default volume
    }
  }

  @override
  Future<void> dispose() async {
    // Controller disposal should be handled by the parent who created it, 
    // or if we created it, we dispose it. Here we receive it, so we assume parent handles it.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: widget.showControls,
          child: Container(
            width: double.infinity,
            color: _playerControlsBgColor,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                Wrap(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.timer),
                          color: Colors.white,
                          onPressed: _cyclePlaybackSpeed,
                        ),
                        Positioned(
                          bottom: 7,
                          right: 3,
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(1),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 1,
                                horizontal: 2,
                              ),
                              child: Text(
                                '${playbackSpeeds.elementAt(playbackSpeedIndex)}x',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      tooltip: 'Get Snapshot',
                      icon: const Icon(Icons.camera),
                      color: Colors.white,
                      onPressed: _createCameraImage,
                    ),
                    // Cast functionality removed as it's not natively supported by media_kit
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<int?>(
                    stream: _player.stream.width,
                    builder: (context, widthSnapshot) {
                      return StreamBuilder<int?>(
                        stream: _player.stream.height,
                        builder: (context, heightSnapshot) {
                          final width = widthSnapshot.data ?? 0;
                          final height = heightSnapshot.data ?? 0;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Size: ${width}x$height',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontSize: 10),
                              ),
                              const SizedBox(height: 5),
                              StreamBuilder<bool>(
                                stream: _player.stream.playing,
                                builder: (context, snapshot) {
                                  return Text(
                                    'Status: ${snapshot.data == true ? "Playing" : "Paused"}',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white, fontSize: 10),
                                  );
                                }
                              ),
                            ],
                          );
                        }
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: transparentColor,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Video(
                    controller: widget.controller,
                    aspectRatio: widget.aspectRatio,
                    controls: NoVideoControls, // We use our own controls
                  ),
                ),
                VideoPlayerControlsWidget(controller: widget.controller),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.showControls,
          child: Container(
            color: _playerControlsBgColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StreamBuilder<bool>(
                  stream: _player.stream.playing,
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return IconButton(
                      color: Colors.white,
                      icon: isPlaying
                          ? const Icon(Icons.pause_circle_outline)
                          : const Icon(Icons.play_circle_outline),
                      onPressed: _togglePlaying,
                    );
                  }
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        position,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: StreamBuilder<Duration>(
                          stream: _player.stream.position,
                          builder: (context, snapshot) {
                            final pos = snapshot.data ?? Duration.zero;
                            final dur = _player.state.duration;
                            final max = dur.inSeconds.toDouble();
                            final value = pos.inSeconds.toDouble().clamp(0.0, max > 0 ? max : 1.0);
                            
                            return Slider(
                              activeColor: Colors.redAccent,
                              inactiveColor: Colors.white70,
                              value: value,
                              min: 0.0,
                              max: max > 0 ? max : 1.0,
                              onChanged: (v) => _onSliderPositionChanged(v),
                            );
                          }
                        ),
                      ),
                      Text(
                        duration,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.showControls,
          child: Container(
            color: _playerControlsBgColor,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(
                  Icons.volume_down,
                  color: Colors.white,
                ),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: 100,
                    value: volumeValue,
                    onChanged: _setSoundVolume,
                  ),
                ),
                const Icon(
                  Icons.volume_up,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _cyclePlaybackSpeed() async {
    playbackSpeedIndex++;
    if (playbackSpeedIndex >= playbackSpeeds.length) {
      playbackSpeedIndex = 0;
    }
    await _player.setRate(playbackSpeeds.elementAt(playbackSpeedIndex));
    setState(() {});
  }

  void _setSoundVolume(double value) {
    setState(() {
      volumeValue = value;
    });
    _player.setVolume(volumeValue);
  }

  void _togglePlaying() async {
    await _player.playOrPause();
  }

  void _onSliderPositionChanged(double progress) {
    setState(() {
      sliderValue = progress.floor().toDouble();
    });
    _player.seek(Duration(seconds: sliderValue.toInt()));
  }

  void _createCameraImage() async {
    final snapshot = await _player.screenshot();
    if (snapshot != null) {
      _overlayEntry?.remove();
      _overlayEntry = _createSnapshotThumbnail(snapshot);
      if (mounted) {
        Overlay.of(context).insert(_overlayEntry!);
      }
    }
  }

  OverlayEntry _createSnapshotThumbnail(Uint8List snapshot) {
    var right = initSnapshotRightPosition;
    var bottom = initSnapshotBottomPosition;
    return OverlayEntry(
      builder: (context) => Positioned(
        right: right,
        bottom: bottom,
        width: 100,
        child: Material(
          elevation: 4.0,
          child: GestureDetector(
            onTap: () async {
              _overlayEntry?.remove();
              _overlayEntry = null;
              await showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(0),
                    content: Image.memory(snapshot),
                  );
                },
              );
            },
            onVerticalDragUpdate: (dragUpdateDetails) {
              bottom -= dragUpdateDetails.delta.dy;
              _overlayEntry!.markNeedsBuild();
            },
            onHorizontalDragUpdate: (dragUpdateDetails) {
              right -= dragUpdateDetails.delta.dx;
              _overlayEntry!.markNeedsBuild();
            },
            onHorizontalDragEnd: (dragEndDetails) {
              if ((initSnapshotRightPosition - right).abs() >= 100) {
                _overlayEntry?.remove();
                _overlayEntry = null;
              } else {
                right = initSnapshotRightPosition;
                _overlayEntry!.markNeedsBuild();
              }
            },
            onVerticalDragEnd: (dragEndDetails) {
              if ((initSnapshotBottomPosition - bottom).abs() >= 100) {
                _overlayEntry?.remove();
                _overlayEntry = null;
              } else {
                bottom = initSnapshotBottomPosition;
                _overlayEntry!.markNeedsBuild();
              }
            },
            child: Image.memory(snapshot),
          ),
        ),
      ),
    );
  }
}
