{
  description = "Pebble SDK - Multi-Environment Development Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { system, pkgs, ... }:
        let
          pkgs-unfree = import inputs.nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              android_sdk.accept_license = true;
            };
          };
        in
        {
          devShells = {
            pebble = import ./shells/pebble.nix { pkgs = pkgs-unfree; };
            flutter = import ./shells/flutter.nix { pkgs = pkgs-unfree; };
            rust = import ./shells/rust.nix { pkgs = pkgs-unfree; };
            nodejs = import ./shells/nodejs.nix { pkgs = pkgs-unfree; };
            default = import ./shells/flutter.nix { pkgs = pkgs-unfree; };
          };
        };
    };
}