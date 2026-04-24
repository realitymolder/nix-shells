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
  ];

  buildInputs = with pkgs; [
    android-sdk.androidsdk
  ];

shellHook = ''
    ANDROID_HOME="${android-sdk.androidsdk}/libexec/android-sdk"
    ANDROID_SDK_ROOT="$ANDROID_HOME"
    export ANDROID_HOME ANDROID_SDK_ROOT
    export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

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