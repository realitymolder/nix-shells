# Flutter Shell

Flutter + Android SDK development environment.

## Packages

- `flutter` SDK
- `android-sdk` (API 36/34, build-tools 28.0.3)
- `clang`, `jdk17`, `nodejs_20`

## Usage

```bash
nix develop       # Default (Flutter)
nix develop .#flutter
flutter --version
flutter doctor
```

## Known Limitations

- Chrome not available (headless environment)
- Network check may fail due to TLS certs in sandbox