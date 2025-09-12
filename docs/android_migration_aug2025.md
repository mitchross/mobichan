# Android & Flutter Migration (August 2025)

This document records the steps taken to migrate the project to align with Google Play August 31 2025 requirements (target API 35) and Flutter 3.35 era tooling.

## Summary of Changes
- Target & Compile SDK: 33 -> 35
- Gradle Wrapper: 8.5 -> 8.9
- Android Gradle Plugin: 7.4.2 -> 8.6.0
- Kotlin: 1.8.22 -> 2.0.20
- Google Services Gradle Plugin: 4.3.10 -> 4.4.2
- Crashlytics Gradle Plugin: 2.7.1 -> 3.0.2
- Added `namespace` in module `build.gradle`
- Updated Firebase BOM to 33.5.1 (adjust as newer stable releases appear)
- Added `arm64-v8a` ABI split (Play Store requires 64-bit support)
- Enabled code and resource shrinking in release builds
- Modernized permissions (granular media + POST_NOTIFICATIONS) and limited legacy WRITE_EXTERNAL_STORAGE
- Performance/build flags added in `gradle.properties` (configuration cache, parallel, etc.)

## Next Manual Steps
1. Ensure local Flutter SDK is latest stable (>=3.35):
   ```bash
   flutter upgrade
   flutter --version
   ```
2. Regenerate platform code after upgrade:
   ```bash
   flutter clean
   flutter pub get
   ```
3. Validate Android build:
   ```bash
   flutter build apk --release
   flutter build appbundle --release
   ```
4. Run integration tests / smoke tests on devices API 28, 33, 35.
5. Request new runtime permissions at appropriate feature entry points:
   - POST_NOTIFICATIONS (Android 13+)
   - READ_MEDIA_IMAGES/VIDEO/AUDIO (Android 13+) – Only ask for what you need.
6. Confirm FCM push notifications work after notification permission denial & acceptance.
7. Review Crashlytics dashboard (mapping file uploading only on release builds).
8. Play Console pre-launch report after uploading new AAB.

## Behavior Changes to Review (API 34/35)
- Notification runtime permission – handle denied state gracefully.
- Foreground service & background execution limits; prefer WorkManager for background tasks.
- Media access: Replace legacy broad storage writes with scoped APIs (e.g., `MediaStore`, SAF) if still using direct file paths.
- PendingIntent mutability: Ensure any custom native Android code sets flags correctly (Flutter/Firebase libs usually handle).

## Permissions Rationale UI
Update in-app copy for new granular permissions. Only request on demand.

## Optional Improvements (Not yet applied)
- Migrate from `splits { abi }` to `ndk { abiFilters }` if using native libs; current approach OK but ensure Play generates all needed configs.
- Evaluate disabling `android.enableJetifier` after verifying no legacy Support libraries remain (speeds build).
- Add strict mode / baseline profile generation for performance (see Jetpack Macro Benchmark or profile-guided optimization).
- Consider enabling Play Integrity / App Check enhancements if using Firebase App Check.

## Dependency Audit
Check for updates:
- Core dependencies (Dio, cached_network_image, video_player, etc.) still compatible with Dart 3.8 & Flutter 3.35.
- Re-run `flutter pub outdated` and selectively upgrade.

## Verification Checklist
- [ ] App launches on Android 14 & 15 preview with no crashes
- [ ] Notifications permission prompt logic correct
- [ ] Media selection / saving still works
- [ ] Crashlytics reporting events
- [ ] Performance acceptable (no jank regressions)
- [ ] AAB passes Play Console target API 35 policy

## Rollback Plan
If issues arise, revert commits touching Gradle & manifest, or temporarily reduce targetSdkVersion to 34 while fixing 35-specific issues (still meets availability for 2025, but new updates after Aug 31 2025 must target 35).

---
_Last updated: 2025-09-12_
