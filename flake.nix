{
  description = "Nix Shells - Multi-Environment Development Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";
  };

  outputs = inputs@{ flake-parts, nixpkgs, devenv, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];

      systems = [ "x86_64-linux" ];

      perSystem = { system, ... }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };

        devenv.shells = {
          pebble = import ./shells/pebble/devenv.nix;
          flutter = import ./shells/flutter/devenv.nix;
          rust = import ./shells/rust/devenv.nix;
          nodejs = import ./shells/nodejs/devenv.nix;
          default = import ./shells/flutter/devenv.nix;
        };
      };
    };
}
