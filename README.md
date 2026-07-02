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

**Local machine** — reference by path:

```bash
devbox shell --config /path/to/nix-shells/shells/flutter
```

**GitHub repo** — reference this flake directly in your project's `devbox.json`:

```json
{
  "packages": {
    "flutter": "latest",
    "jdk17": "latest",
    "gradle": "latest",
    "qemu_kvm": "latest",
    "libsecret": "latest",
    "nix": "latest",
    "github:realitymolder/nix-shells#androidSdk": "latest"
  },
  "shell": {
    "init_hook": [
      "ANDROID_SDK_STORE=$(nix build --no-link --print-out-paths 'github:realitymolder/nix-shells#androidSdk' 2>/dev/null || true)",
      "if [ -n \"$ANDROID_SDK_STORE\" ]; then",
      "  export ANDROID_HOME=\"$ANDROID_SDK_STORE/libexec/android-sdk\"",
      "  export ANDROID_SDK_ROOT=\"$ANDROID_HOME\"",
      "  flutter config --android-sdk \"$ANDROID_HOME\" 2>/dev/null || true",
      "fi"
    ]
  }
}
```

The nixpkgs `flutter` + `jdk17` + this flake's `androidSdk` is all that's needed for `flutter doctor` to pass.

## Requirements

- Nix 2.18+ with flakes enabled
- `nix-daemon` running (for sandboxed downloads)
- devbox CLI (optional for Flutter shell; install via `nix shell nixpkgs#devbox`)
- devenv CLI (optional, for `devenv shell` usage with other shells)
