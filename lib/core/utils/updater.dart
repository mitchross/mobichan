import 'package:flutter/material.dart';
import 'package:mobichan_domain/mobichan_domain.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Updater {
  static Future<bool> checkForUpdates(BuildContext context) async {
    Release latestRelease =
        await context.read<ReleaseRepository>().getLatestRelease();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // Parse versions manually instead of using version package
    final latestVersion = _parseVersion(latestRelease.tagName.substring(1));
    final currentVersion = _parseVersion(packageInfo.version);

    return Future.value(_compareVersions(latestVersion, currentVersion) > 0);
  }

  /// Parse version string into list of integers [major, minor, patch]
  static List<int> _parseVersion(String version) {
    // Remove any pre-release or build metadata (e.g., "1.2.3-beta+build")
    final versionCore = version.split('-').first.split('+').first;
    return versionCore.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  }

  /// Compare two version lists, returns 1 if v1 > v2, -1 if v1 < v2, 0 if equal
  static int _compareVersions(List<int> v1, List<int> v2) {
    final maxLength = v1.length > v2.length ? v1.length : v2.length;

    for (int i = 0; i < maxLength; i++) {
      final part1 = i < v1.length ? v1[i] : 0;
      final part2 = i < v2.length ? v2[i] : 0;

      if (part1 > part2) return 1;
      if (part1 < part2) return -1;
    }

    return 0;
  }
}
