{ pkgs, lib, ... }:

{
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_24;
    bun.enable = true;
    pnpm.enable = true;
  };

  packages = with pkgs; [
    eslint
    prettier
    typescript-go
    tsx
    just
  ];
}
