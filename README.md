# Nix Shells

Multi-environment development shells for Nix.

| Shell | Tool | Usage |
|-------|------|-------|
| Flutter + Android SDK | [devbox](https://www.jetify.com/devbox/) | `cd shells/flutter && devbox shell` |
| Pebble watch SDK | [devenv](https://devenv.sh) | `nix develop .#pebble` |
| Rust toolchain | [devenv](https://devenv.sh) | `nix develop .#rust` |
| Node.js + Bun | [devenv](https://devenv.sh) | `nix develop .#nodejs` |

## Quick Start (Flutter)

```bash
cd shells/flutter
devbox shell
flutter doctor
```

### Use from another project

From any directory on your machine, activate the Flutter shell without leaving your project:

```bash
devbox shell --config /path/to/nix-shells/shells/flutter
```

Or create a thin wrapper script in your project (e.g. `bin/dev.sh`):

```bash
#!/usr/bin/env bash
exec devbox shell --config /path/to/nix-shells/shells/flutter
```

Make it executable and run `./bin/dev.sh` from your project.

## Requirements

- Nix 2.18+ with flakes enabled
- `nix-daemon` running (for sandboxed downloads)
- devbox CLI (optional for Flutter shell; install via `nix shell nixpkgs#devbox`)
- devenv CLI (optional, for `devenv shell` usage with other shells)
