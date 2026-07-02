{
  description = "Custom Android SDK for Flutter development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };
    in
    {
      packages.${system} = rec {
        androidSdk = let
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
              "android-googlexr-license"
            ];
          };
        in androidComposition.androidsdk;

        default = androidSdk;
      };
    };
}
