# Nix Shells

Multi-environment devenv-based development flake.

## Quick Start

```bash
nix develop --no-pure-eval       # Flutter (default)
```

## Environments

| Command | Description |
|---------|-------------|
| `nix develop --no-pure-eval` | Flutter + Android SDK (default) |
| `nix develop --no-pure-eval .#pebble` | Pebble watch SDK |
| `nix develop --no-pure-eval .#rust` | Rust toolchain |
| `nix develop --no-pure-eval .#nodejs` | Node.js + Bun |

All shells are backed by [devenv](https://devenv.sh) and can also be entered via `devenv shell` from the respective shell directory.

## Requirements

- Nix 2.18+ with flakes enabled
- `nix-daemon` running (for sandboxed downloads)
- devenv CLI (optional, for `devenv shell` usage)
