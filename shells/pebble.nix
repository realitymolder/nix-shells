{ pkgs }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
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
}