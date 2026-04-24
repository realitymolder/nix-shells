{ pkgs }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    flutter
    clang
    git
    nodejs_20
    jdk17
  ];

  buildInputs = with pkgs; [
    (pkgs.androidenv.composeAndroidPackages {
      buildToolsVersions = [ "34.0.0" ];
      platformVersions = [ "34" ];
      abiVersions = [ "armeabi-v7a" "arm64-v8a" "x86_64" "x86" ];
    }).androidsdk
  ];

  shellHook = ''
    export ANDROID_HOME="$(dirname $(dirname $(readlink -f $(which sdkmanager 2>/dev/null))))"
    export ANDROID_SDK_ROOT=$ANDROID_HOME
    export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

    echo "═══════════════════════════════════════"
    echo "  Flutter + Android SDK Ready!"
    echo "  Run: flutter --version"
    echo "  Run: flutter doctor"
    echo "═══════════════════════════════════════"
    flutter --version 2>/dev/null || true
  '';
}