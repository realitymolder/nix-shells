# Flutter Shell (devbox)

Flutter + Android SDK development environment powered by [devbox](https://www.jetify.com/devbox/).

## Packages

- `flutter` SDK (from nixpkgs)
- `jdk17` (from nixpkgs)
- `gradle` (from nixpkgs)
- `qemu_kvm` (from nixpkgs)
- `libsecret` (from nixpkgs)
- Android SDK (custom composition via local flake: API 36, build-tools 36.0.0, platform-tools 36.0.2, cmdline-tools 8.0)

## Usage

```bash
cd shells/flutter
devbox shell
flutter --version
flutter doctor
```

### From your project directory

Activate the Flutter shell from any project without leaving it:

```bash
devbox shell --config /path/to/nix-shells/shells/flutter
```

Or create a thin wrapper in your project (e.g. `bin/dev.sh`):

```bash
#!/usr/bin/env bash
exec devbox shell --config /path/to/nix-shells/shells/flutter
```

The `init_hook` automatically:
- Sets `ANDROID_HOME` / `ANDROID_SDK_ROOT` to the composed Android SDK
- Sets `JAVA_HOME` to the JDK 17 in the shell
- Configures `flutter config --android-sdk` so the Flutter tool uses the correct SDK path
- Adds `~/.pub-cache/bin` to `PATH`

## Android Emulator

```bash
# List available emulators
flutter emulators

# Create and launch an AVD (requires an AVD image to exist)
flutter emulators --create
flutter emulators launch <avd_id>

# Or run directly on emulator
flutter run -d <device_id>
```

## Flutter Web

```bash
flutter run -d chrome
flutter devices
```

## Known Limitations

- Network check may fail due to TLS certs in sandbox