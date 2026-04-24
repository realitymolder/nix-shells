{ pkgs }:
let
  android-sdk = pkgs.androidenv.composeAndroidPackages {
    buildToolsVersions = [ "28.0.3" ];
    platformVersions = [ "36" "34" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" "x86_64" "x86" ];
    includeEmulator = true;
    emulatorVersion = "36.1.0";
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
  ];

  buildInputs = with pkgs; [
    android-sdk.androidsdk
  ];

  shellHook = ''
    # Copy SDK to writable location
    export ANDROID_SDK_ROOT="$HOME/.android/sdk"
    export ANDROID_HOME="$ANDROID_SDK_ROOT"
    mkdir -p "$ANDROID_SDK_ROOT"

    if [ ! -d "$ANDROID_SDK_ROOT/platforms" ]; then
      cp -r "${android-sdk.androidsdk}/libexec/android-sdk/"* "$ANDROID_SDK_ROOT/"
    fi

    export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH"
    export CHROME_EXECUTABLE="${pkgs.ungoogled-chromium}/bin/chromium"

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