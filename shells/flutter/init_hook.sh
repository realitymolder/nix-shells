ANDROID_SDK_STORE=$(nix build --no-link --print-out-paths 'path:./sdk#androidSdk' 2>/dev/null || true)
if [ -n "$ANDROID_SDK_STORE" ]; then
  export ANDROID_HOME="$ANDROID_SDK_STORE/libexec/android-sdk"
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
  export GRADLE_OPTS="-Dorg.gradle.project.android.aapt2FromMavenOverride=$ANDROID_HOME/build-tools/36.0.0/aapt2"
  flutter config --android-sdk "$ANDROID_HOME" 2>/dev/null || true
fi

_JAVA_BIN=$(readlink -f "$(which java 2>/dev/null)" 2>/dev/null || true)
if [ -n "$_JAVA_BIN" ]; then
  export JAVA_HOME=$(dirname "$(dirname "$_JAVA_BIN")")
fi

export PATH="$PATH:${PUB_CACHE:-$HOME/.pub-cache}/bin"

echo "═══════════════════════════════════════"
echo "  Flutter Development Ready (devbox)"
echo "  Run: flutter doctor"
echo "═══════════════════════════════════════"
flutter --version 2>/dev/null || true
