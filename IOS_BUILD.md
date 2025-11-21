# iOS Build Instructions

This document contains instructions for building Mobichan on iOS.

## Prerequisites

- Xcode 15 or later
- CocoaPods installed (`sudo gem install cocoapods`)
- Flutter SDK (3.8.0 or later)
- macOS for building iOS apps

## Clean Build Steps

If you're experiencing build issues, follow these steps for a clean build:

### 1. Clean Flutter Build Cache

```bash
flutter clean
```

### 2. Remove iOS Build Artifacts

```bash
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec
cd ..
```

### 3. Get Flutter Dependencies

```bash
flutter pub get
```

### 4. Install CocoaPods Dependencies

```bash
cd ios
pod install --repo-update
cd ..
```

### 5. Build for iOS

For simulator:
```bash
flutter build ios --simulator
```

For device:
```bash
flutter build ios --release
```

Or run directly:
```bash
flutter run -d <device-id>
```

## Common Issues and Solutions

### Issue: "Undefined symbols" or linking errors

**Solution:** Run a clean build:
```bash
flutter clean
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
flutter build ios
```

### Issue: "Module not found" errors

**Solution:** Ensure all pods are properly installed:
```bash
cd ios
pod deintegrate
pod install --repo-update
cd ..
```

### Issue: VLC Player build errors

The app uses `flutter_vlc_player` for video playback. If you encounter VLC-related build errors:

1. Ensure your iOS deployment target is set to 16.0 or higher
2. Clean and rebuild: `flutter clean && cd ios && pod install && cd ..`
3. Check that VLC pod is properly installed in `ios/Podfile.lock`

### Issue: Firebase build errors

If Firebase pods fail to build:

1. Update CocoaPods: `sudo gem install cocoapods`
2. Update pod repo: `pod repo update`
3. Clean install: `cd ios && rm -rf Pods Podfile.lock && pod install && cd ..`

## Build Configuration

### Minimum iOS Version
- **iOS 16.0** or later

### Key Features Enabled
- ✅ Impeller rendering engine (better performance)
- ✅ High refresh rate support (120Hz)
- ✅ Swift 5.0
- ✅ Module headers
- ❌ Bitcode (disabled, not needed for iOS 16+)

### Privacy Permissions
The app requires the following permissions (configured in Info.plist):
- Camera access (for capturing photos/videos)
- Microphone access (for recording audio)
- Photo Library access (read and write)
- Network access (for API calls)
- Tracking (for Firebase Analytics)

## Troubleshooting

### Still having issues?

1. **Check Xcode version**: Ensure you're using Xcode 15 or later
2. **Check Flutter version**: Run `flutter doctor` to verify installation
3. **Check pod versions**: Run `pod --version` (should be 1.12.0 or later)
4. **Clean everything**:
   ```bash
   flutter clean
   cd ios
   rm -rf Pods Podfile.lock DerivedData build
   pod cache clean --all
   pod install --repo-update
   cd ..
   flutter build ios
   ```

### Architecture Issues

If you get architecture-related errors on Apple Silicon Macs:
- The Podfile is configured to exclude `arm64` and `i386` for simulator builds
- Make sure you're not trying to run an x86_64 simulator on Apple Silicon

## Notes

- The first build after cleaning may take 10-15 minutes
- Subsequent builds should be much faster
- Firebase pods can be particularly slow to download
- VLC player pod is large (~100MB) and may take time to download

## Support

If you continue to have build issues, please provide:
1. Xcode version (`xcodebuild -version`)
2. Flutter version (`flutter --version`)
3. Full build error log
4. Output of `flutter doctor`
