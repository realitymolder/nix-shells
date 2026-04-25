{ pkgs }:
let
  android-sdk = pkgs.androidenv.composeAndroidPackages {
    buildToolsVersions = [ "28.0.3" ];
    platformVersions = [ "36" "34" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" "x86_64" "x86" ];
    includeEmulator = true;
    emulatorVersion = "36.1.9";
  };
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    flutter
    clang
    git
    nodejs_20
    jdk17
    ungoogled-chromium
    rsync
  ];

  buildInputs = with pkgs; [
    android-sdk.androidsdk
  ];

shellHook = ''
    # Clear any existing Android env vars from parent shell
    unset ANDROID_HOME ANDROID_SDK_ROOT ANDROID_EMULATOR_HOME AVD_HOME 2>/dev/null

    # Force our SDK location
    export ANDROID_SDK_ROOT="$HOME/.local/android-sdk"
    export ANDROID_HOME="$ANDROID_SDK_ROOT"
    export ANDROID_EMULATOR_HOME="$HOME/.local/android-emulator"
    export AVD_HOME="$HOME/.android/avd"
    mkdir -p "$ANDROID_SDK_ROOT" "$ANDROID_EMULATOR_HOME"

    # Copy entire SDK directory tree
    cp -rT "${android-sdk.androidsdk}/libexec/android-sdk" "$ANDROID_SDK_ROOT"

    # Fix emulator wrapper that points to Nix store - use the actual binary
    if grep -q "/nix/store" "$ANDROID_SDK_ROOT/emulator/emulator" 2>/dev/null; then
      # Copy the actual emulator binary (not the wrapper)
      cp "${android-sdk.androidsdk}/libexec/android-sdk/emulator/.emulator-wrapped" "$ANDROID_SDK_ROOT/emulator/emulator"
      chmod +x "$ANDROID_SDK_ROOT/emulator/emulator"

      # Also set library path for emulator
      export LD_LIBRARY_PATH="$ANDROID_SDK_ROOT/emulator/lib64:$ANDROID_SDK_ROOT/emulator/lib:$LD_LIBRARY_PATH"
    fi

    # Fix platform-tools adb if it points to Nix store
    if [ -L "$ANDROID_SDK_ROOT/platform-tools/adb" ]; then
      rm "$ANDROID_SDK_ROOT/platform-tools/adb"
      cp "$(readlink -f "${android-sdk.androidsdk}/libexec/android-sdk/platform-tools/adb")" "$ANDROID_SDK_ROOT/platform-tools/adb"
    fi

    # Tell Flutter to use our SDK
    flutter config --android-sdk="$ANDROID_SDK_ROOT" 2>/dev/null || true

    export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$PATH"
    export CHROME_EXECUTABLE="${pkgs.ungoogled-chromium}/bin/chromium"

    echo "ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT"

    yes | flutter doctor --android-licenses 2>/dev/null || true
    yes | "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" --licenses 2>/dev/null || true

    echo "═══════════════════════════════════════"
    echo "  Flutter + Android SDK Ready!"
    echo "  Run: flutter --version"
    echo "  Run: flutter doctor"
    echo "════════════════════════════════════════════"
    flutter --version 2>/dev/null || true
  '';
}
