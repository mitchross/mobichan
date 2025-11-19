import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobichan/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:mobichan/dependency_injector.dart' as dependency_injector;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInAnonymously();
  await FirebaseAppCheck.instance.activate();

  // Optimized image cache for better memory management (150MB instead of 300MB)
  // This prevents OOM crashes on lower-end devices while still providing good performance
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 150;
  PaintingBinding.instance.imageCache.maximumSize = 100; // Limit number of cached images

  await EasyLocalization.ensureInitialized();
  await dependency_injector.init();
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
