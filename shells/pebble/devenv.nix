{ pkgs, lib, ... }:

{
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_20;
  };

  packages = with pkgs; [
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
  ];

  scripts.pebble.exec = ''
    export PATH="$HOME/.local/bin:$PATH"
    if ! command -v pebble &> /dev/null; then
      echo "Installing pebble-tool..."
      uv tool install pebble-tool --python 3.13
    fi
    pebble "$@"
  '';
}
