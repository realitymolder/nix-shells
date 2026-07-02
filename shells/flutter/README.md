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

### From your project directory (local)

```bash
devbox shell --config /path/to/nix-shells/shells/flutter
```

Or create a thin wrapper in your project (e.g. `bin/dev.sh`):

```bash
#!/usr/bin/env bash
exec devbox shell --config /path/to/nix-shells/shells/flutter
```

### From a remote project (GitHub repo)

Reference the Android SDK from this flake, plus the init_hook inline:

Create `devbox.json` in your project:

```json
{
  "packages": [
    "flutter",
    "jdk17",
    "gradle",
    "qemu_kvm",
    "libsecret",
    "nix",
    "github:realitymolder/nix-shells#androidSdk"
  ],
  "env": {
    "QT_QPA_PLATFORM": "wayland;xcb",
    "PUB_CACHE": "$HOME/.pub-cache"
  },
  "shell": {
    "init_hook": [
      "ANDROID_SDK_STORE=$(nix build --no-link --print-out-paths 'github:realitymolder/nix-shells#androidSdk' 2>/dev/null || true)",
      "if [ -n \"$ANDROID_SDK_STORE\" ]; then",
      "  export ANDROID_HOME=\"$ANDROID_SDK_STORE/libexec/android-sdk\"",
      "  export ANDROID_SDK_ROOT=\"$ANDROID_HOME\"",
      "  GRADLE_OPTS=\"-Dorg.gradle.project.android.aapt2FromMavenOverride=$ANDROID_HOME/build-tools/36.0.0/aapt2\"",
      "  flutter config --android-sdk \"$ANDROID_HOME\" 2>/dev/null || true",
      "fi",
      "JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java 2>/dev/null))) 2>/dev/null || true)",
      "export JAVA_HOME",
      "export PATH=\"$PATH:${PUB_CACHE:-$HOME/.pub-cache}/bin\""
    ]
  }
}
```

Now any developer cloning your repo gets the same Flutter + Android SDK environment.

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