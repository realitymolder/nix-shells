# Flutter Shell

Flutter + Android SDK development environment.

## Packages

- `flutter` SDK
- `android-sdk` (API 36/34, build-tools 28.0.3)
- `android-emulator` (API 36)
- `ungoogled-chromium` (for Flutter web)
- `clang`, `jdk17`, `nodejs_20`

## Usage

```bash
nix develop       # Default (Flutter)
nix develop .#flutter
flutter --version
flutter doctor
```

## Android Emulator

The shell automatically:
- Copies Android SDK to `~/.local/android-sdk`
- Creates AVD "pixel34" with system image if not present

```bash
# List available emulators
flutter emulators

# Launch an emulator
flutter emulators launch pixel34

# Or run directly on emulator
flutter run -d pixel34
```

## Flutter Web

```bash
# Run on Chrome (uses ungoogled-chromium)
flutter run -d chrome

# Or list available devices first
flutter devices
flutter run -d <device_id>
```

## Known Limitations

- Network check may fail due to TLS certs in sandbox