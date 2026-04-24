# Pebble Shell

Pebble watch SDK development environment.

## Packages

- `pebble-tool` (via uv)
- SDL2, freetype, libpng, libjpeg (graphics)
- dtc (device tree compiler)
- nodejs_20

## Usage

```bash
nix develop .#pebble
pebble sdk install latest
pebble new-project my-app
```