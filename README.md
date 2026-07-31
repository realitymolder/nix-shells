# Nix Shells

Multi-environment development shells for Nix, powered by [devenv](https://devenv.sh).

Each shell is a standalone devenv project (`devenv.yaml` + `devenv.nix`).

| Shell | Usage |
|-------|-------|
| Flutter + Android SDK | `cd shells/flutter && devenv shell` |
| Pebble watch SDK | `cd shells/pebble && devenv shell` |
| Rust toolchain | `cd shells/rust && devenv shell` |
| Node.js 24 + Bun + pnpm | `cd shells/nodejs && devenv shell` |

## Quick Start (Flutter)

```bash
cd shells/flutter
devenv shell
flutter doctor
```

## Use in your own project

Merge a shell into your project's `devenv.yaml`:

```yaml
imports:
  - /path/to/nix-shells/shells/flutter
```

Or copy the `devenv.nix` module into your project. For Flutter + Android SDK:

```nix
{ pkgs, ... }:
{
  android = {
    enable = true;
    flutter.enable = true;
  };
}
```

## Requirements

- Nix 2.18+ (flakes not required)
- `nix-daemon` running (for sandboxed downloads)
- devenv CLI 2.x (install via `nix shell nixpkgs#devenv`)
