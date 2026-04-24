# Plan: Convert pebble-sdk to Multi-Environment Nix Flake

## Goal
Transform the single `pebble-sdk` flake into a multi-environment flake that provides isolated development environments for each toolchain (Pebble, Flutter, Rust, Node.js).

## Current State
- Single `flake.nix` with one `devShells.default` providing:
  - git, cpio, wget, unzip, uv, SDL2, pixman, dtc, freetype, libpng, libjpeg, zlib, nodejs
  - pebble-tool installed via uv

## Architecture

### Approach: Named DevShells via flake-parts

Using `hercules-ci/flake-parts` (already in use), define each environment as a named devShell. Users select environment via:
```bash
nix develop .#<name>
```

### Environments to Implement

| Name | Description | Key Packages |
|------|-------------|--------------|
| `pebble` | Existing Pebble watch SDK (keep current) | pebble-tool (uv), git, wget, unzip, SDL2, etc. |
| `flutter` | Flutter mobile SDK + Android SDK | flutter, android-sdk, clang, git, nodejs |
| `rust` | Rust toolchain | rustup, cargo, rustfmt, clippy, rust-analyzer |
| `nodejs` | Node.js/JavaScript | nodejs, pnpm, bun, eslint, prettier, typescript |

## Implementation Details

### flake.nix Changes

1. Keep existing flake-parts structure
2. Add each environment as named devShell under `perSystem`
3. Each environment gets its own `nativeBuildInputs` and `shellHook`
4. Add `flutter-overlay` input for Flutter + Android SDK

### Imports Required

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  flake-parts.url = "github:hercules-ci/flake-parts";
  flutter-overlay.url = "github:nix-community/flutter-overlay";
  rust-overlay.url = "github:nix-community/rust-overlay";
};
```

### Environment Definitions

```nix
devShells = {
  pebble = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [ git wget unzip uv SDL2 pixman dtc freetype libpng libjpeg zlib nodejs ];
    shellHook = ''...'';
  };
  
  flutter = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [ flutter android-sdk clang git ];
    shellHook = ''...'';
  };
  
  rust = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [ rustup cargo rustfmt clippy rust-analyzer ];
    shellHook = ''...'';
  };
  
  nodejs = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [ nodejs pnpm bun eslint prettier typescript ];
    shellHook = ''...'';
  };
};
```

### Optional: Legacy Default

Set `devShells.default` to `flutter` - this becomes the environment loaded by `nix develop` without a selector.

## File Changes

- **flake.nix** - Rewrite to add multi-environment support
- **flake.lock** - May need update for new inputs (e.g., flutter-overlay)

## Migration Path for Users

```bash
# Loads Flutter by default (most common use case)
nix develop

# Explicit selection also works
nix develop .#flutter   # Flutter (same as default)
nix develop .#pebble    # Pebble only
nix develop .#rust     # Rust only
nix develop .#nodejs   # Node.js only
```

## Open Questions (All Addressed)

1. ~~Should `devShells.default` be removed to enforce explicit environment selection?~~ → **No, set default to `flutter`**
2. ~~Add Android SDK for Flutter?~~ → **Yes, include Android SDK + accept licenses**
3. ~~Include additional Node.js tools?~~ → **Yes, include pnpm, bun, eslint, prettier, typescript**

## Risks

- **Flutter closure size**: Full Flutter SDK is large (~10GB). Using flutter-overlay helps manage this.
- **Android SDK**: ~2GB additional; needed for APK builds but can be skipped if not needed.

## Execution Steps

1. **Update flake.nix inputs** - Add flutter-overlay, rust-overlay
2. **Rewrite devShells** - Create each named environment:
   - `pebble` - Keep existing packages + pebble-tool
   - `flutter` - Flutter SDK + Android SDK + clang
   - `rust` - rustup + cargo + rustfmt + clippy
   - `nodejs` - nodejs + pnpm + bun + eslint + prettier + typescript
3. **Set default to flutter** - Link devShells.default to flutter environment
4. **Run `nix flake update`** - Lock new inputs
5. **Test each environment** - `nix develop .#<name>` for each
6. **Verify default** - `nix develop` loads Flutter