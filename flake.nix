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
            pebble = pkgs-unfree.mkShell {
              nativeBuildInputs = with pkgs-unfree; [
                git
                cpio
                wget
                unzip
                uv
                SDL2
                SDL2_image
                pixman
                dtc
                freetype
                libpng
                libjpeg
                zlib
                nodejs_20
              ];

              shellHook = ''
                if ! command -v pebble &> /dev/null; then
                  echo "Installing pebble-tool..."
                  uv tool install pebble-tool --python 3.13
                fi

                export PATH="$HOME/.local/bin:$PATH"

                echo "═══════════════════════════════════════"
                echo "  Pebble SDK Ready!"
                echo "  Run: pebble sdk install latest"
                echo "  Run: pebble new-project <name>"
                echo "═══════════════════════════════════════"
                pebble --version 2>/dev/null || true
              '';
            };

            flutter = pkgs-unfree.mkShell {
              nativeBuildInputs = with pkgs-unfree; [
                flutter
                clang
                git
                nodejs_20
                jdk17
              ];

              buildInputs = with pkgs-unfree; [
                (pkgs-unfree.androidenv.composeAndroidPackages {
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
            };

            rust = pkgs-unfree.mkShell {
              nativeBuildInputs = with pkgs-unfree; [
                rustup
                cargo
                rustfmt
                clippy
                rust-analyzer
                lldb
                gdb
              ];

              shellHook = ''
                echo "═══════════════════════════════════════"
                echo "  Rust Development Ready!"
                echo "  Run: rustup show"
                echo "  Run: cargo --version"
                echo "═══════════════════════════════════════"
                rustc --version 2>/dev/null || true
                cargo --version 2>/dev/null || true
              '';
            };

            nodejs = pkgs-unfree.mkShell {
              nativeBuildInputs = with pkgs-unfree; [
                nodejs_20
                bun
                pnpm_9
                eslint
                prettier
                typescript
                ts-node
                just
              ];

              shellHook = ''
                echo "═══════════════════════════════════════"
                echo "  Node.js Development Ready!"
                echo "  Run: node --version"
                echo "  Run: bun --version"
                echo "═══════════════════════════════════════"
                node --version 2>/dev/null || true
                bun --version 2>/dev/null || true
              '';
            };

            default = pkgs-unfree.mkShell {
              nativeBuildInputs = with pkgs-unfree; [
                flutter
                clang
                git
                nodejs_20
                jdk17
              ];

              buildInputs = with pkgs-unfree; [
                (pkgs-unfree.androidenv.composeAndroidPackages {
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
                echo "  Default environment loaded."
                echo "  Run: flutter --version"
                echo "  Run: flutter doctor"
                echo "═══════════════════════════════════════"
                flutter --version 2>/dev/null || true
              '';
            };
          };
        };
    };
}