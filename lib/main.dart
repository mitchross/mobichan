import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mobichan/app.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:mobichan/dependency_injector.dart' as dependency_injector;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optimized image cache for better memory management (150MB instead of 300MB)
  // This prevents OOM crashes on lower-end devices while still providing good performance
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 150;
  PaintingBinding.instance.imageCache.maximumSize = 100; // Limit number of cached images

  await EasyLocalization.ensureInitialized();
  await dependency_injector.init();
  MediaKit.ensureInitialized();
  timeago.setLocaleMessages('fr', timeago.FrMessages());

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
        Locale('nb', 'NO'),
        Locale('tr', 'TR'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const App(),
    ),
  );
}
