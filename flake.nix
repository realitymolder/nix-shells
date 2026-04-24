{
  description = "Pebble SDK Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { system, ... }:
        let
          pkgs-unfree = import inputs.nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
          };
        in
        {
          devShells.default = pkgs-unfree.mkShell {
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
              nodejs
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
        };
    };
}