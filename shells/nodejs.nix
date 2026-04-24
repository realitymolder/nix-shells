{ pkgs }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nodejs_20
    bun
    pnpm_9
    eslint
    prettier
    typescript
    ts-node
    just
  ];

  shellHook = ''
    echo "═══════════════════════════════════════"
    echo "  Node.js Development Ready!"
    echo "  Run: node --version"
    echo "  Run: bun --version"
    echo "═══════════════════════════════════════"
    node --version 2>/dev/null || true
    bun --version 2>/dev/null || true
  '';
}