# Flutter Shell

Flutter + Android SDK development environment.

## Packages

- `flutter` SDK
- `android-sdk` (API 36/34, build-tools 28.0.3)
- `android-emulator` (API 36)
- `clang`, `jdk17`, `nodejs_20`

## Usage

```bash
nix develop       # Default (Flutter)
nix develop .#flutter
flutter --version
flutter doctor
```

## Android Emulator

```bash
# List available emulators
flutter emulators

# Create a new emulator (if none exist)
flutter emulators --create "flutter_emulator"

# Launch an emulator
flutter emulators launch <emulator_id>

# Or run directly on emulator
flutter run -d <emulator_id>
```

## Known Limitations

- Chrome not available (headless environment)
- Network check may fail due to TLS certs in sandbox