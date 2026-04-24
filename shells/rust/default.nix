{ pkgs }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    rustup
    cargo
    rustfmt
    clippy
    rust-analyzer
    lldb
    gdb
  ];

  shellHook = ''
    echo "═══════════════════════════════════════"
    echo "  Rust Development Ready!"
    echo "  Run: rustup show"
    echo "  Run: cargo --version"
    echo "═══════════════════════════════════════"
    rustc --version 2>/dev/null || true
    cargo --version 2>/dev/null || true
  '';
}