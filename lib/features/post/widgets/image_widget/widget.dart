import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobichan/dependency_injector.dart';
import 'package:mobichan/features/setting/setting.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'image_widget.dart';

class ImageWidget extends StatefulWidget {
  final Board board;
  final Post post;
  final bool fullRes;

  const ImageWidget({
    Key? key,
    required this.board,
    required this.post,
    this.fullRes = false,
  }) : super(key: key);

  @override
  State<ImageWidget> createState() => ImageWidgetState();
}

class ImageWidgetState extends State<ImageWidget> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription; // Changed type

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.filename != null) {
      return BlocBuilder<SettingsCubit, List<Setting>?>(
          builder: (context, settings) {
            if (settings != null) {
              return FutureBuilder<String>(
                future: _getImageUrl(
                  widget.post,
                  widget.board,
                  settings,
                  _connectionStatus,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return buildImage(snapshot.data!, settings);
                  } else {
                    return buildImage(
                        widget.post.getThumbnailUrl(widget.board)!,settings);
                  }
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> resultList; // Changed type from ConnectivityResult to List<ConnectivityResult>
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      resultList = await _connectivity.checkConnectivity(); // Assigns List<ConnectivityResult>
    } on PlatformException catch (e) {
      log(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(resultList); // Now correctly passes List<ConnectivityResult>
  }

  // Updated to handle List<ConnectivityResult>
  Future<void> _updateConnectionStatus(List<ConnectivityResult> resultList) async {
    ConnectivityResult newStatus;
    if (resultList.contains(ConnectivityResult.wifi)) {
      newStatus = ConnectivityResult.wifi;
    } else if (resultList.contains(ConnectivityResult.mobile)) {
      newStatus = ConnectivityResult.mobile;
    } else if (resultList.contains(ConnectivityResult.ethernet)) {
      newStatus = ConnectivityResult.ethernet;
    } else if (resultList.contains(ConnectivityResult.vpn)) {
      newStatus = ConnectivityResult.vpn;
    } else if (resultList.contains(ConnectivityResult.none) || resultList.isEmpty) {
      newStatus = ConnectivityResult.none;
    } else {
      newStatus = resultList.first; // Fallback to the first reported status
    }

    if (_connectionStatus != newStatus) {
      setState(() {
        _connectionStatus = newStatus;
      });
    }
  }

  Future<String> _getImageUrl(
    Post post,
    Board board,
    List<Setting> settings,
    ConnectivityResult connectivityStatus,
  ) async {
    final highResolutionThumbnailsMobile =
        settings.findByTitle('high_res_thumbnails_mobile')?.value as bool;

    final highResolutionThumbnailsWifi =
        settings.findByTitle('high_res_thumbnails_wifi')?.value as bool;

    if ((widget.fullRes ||
            ((connectivityStatus == ConnectivityResult.wifi &&
                    highResolutionThumbnailsWifi) ||
                (connectivityStatus == ConnectivityResult.mobile &&
                    highResolutionThumbnailsMobile))) &&
        !post.isWebm) {
      return post.getImageUrl(board)!;
    } else {
      return post.getThumbnailUrl(board)!;
    }
  }
}
