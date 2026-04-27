{ pkgs }:
let
  flutterVersion = pkgs.flutterBinary;
in
let
  androidEnv = pkgs.androidenv.override { licenseAccepted = true; };
  androidComposition = androidEnv.composeAndroidPackages {
    cmdLineToolsVersion = "8.0";
    platformToolsVersion = "36.0.2";
    buildToolsVersions = [ "36.0.0" ];
    platformVersions = [ "36" ];
    abiVersions = [ "x86_64" ];
    includeNDK = false;
    includeSystemImages = true;
    includeEmulator = true;
    useGoogleAPIs = true;
    extraLicenses = [
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "android-sdk-license"
      "android-sdk-preview-license"
      "google-gdk-license"
      "intel-android-extra-license"
      "intel-android-sysimage-license"
      "mips-android-sysimage-license"
    ];
  };
  androidSdk = androidComposition.androidsdk;
in
pkgs.mkShell rec {
  ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
  ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
  JAVA_HOME = pkgs.jdk17.home;
  FLUTTER_ROOT = flutterVersion;
  DART_ROOT = "${flutterVersion}/bin/cache/dart-sdk";
  GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/36.0.0/aapt2";
  QT_QPA_PLATFORM = "wayland;xcb";
buildInputs = [
    androidSdk
    flutterVersion
    pkgs.ca-certificates
    pkgs.qemu_kvm
    pkgs.gradle
    pkgs.jdk17
    pkgs.libsecret
  ];
  nativeBuildInputs = with pkgs; [
    pkg-config
    libsecret.dev
  ];
  LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [pkgs.vulkan-loader pkgs.libGL]}";
  shellHook = ''
    export SSL_CERT_FILE="${pkgs.ca-certificates}/etc/ssl/certs/ca-bundle.crt"
    export SSL_CERT_DIR="${pkgs.ca-certificates}/etc/ssl/certs"
    if [ -z "$PUB_CACHE" ]; then
      export PATH="$PATH:$HOME/.pub-cache/bin"
    else
      export PATH="$PATH:$PUB_CACHE/bin"
    fi
  '';
}
