# Pebble SDK

Multi-environment Nix flake for development.

## Quick Start

```bash
nix develop       # Flutter (default)
```

## Environments

| Command | Description |
|---------|-------------|
| `nix develop` | Flutter + Android SDK (default) |
| `nix develop .#pebble` | Pebble watch SDK |
| `nix develop .#rust` | Rust toolchain |
| `nix develop .#nodejs` | Node.js + Bun |

## Requirements

- Nix 2.18+ with flakes enabled
- `nix-daemon` running (for sandboxed downloads)