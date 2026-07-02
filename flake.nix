{
  description = "Nix Shells - Multi-Environment Development Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs = { nixpkgs.follows = "nixpkgs"; };
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
  };

  outputs = inputs@{ flake-parts, nixpkgs, devenv, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];

      systems = [ "x86_64-linux" ];

      perSystem = { system, ... }: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };
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
      in {
        _module.args.pkgs = pkgs;

        packages.androidSdk = androidComposition.androidsdk;

        devenv.shells = {
          pebble = import ./shells/pebble/devenv.nix;
          rust = import ./shells/rust/devenv.nix;
          nodejs = import ./shells/nodejs/devenv.nix;
          default = import ./shells/rust/devenv.nix;
        };
      };
    };
}
