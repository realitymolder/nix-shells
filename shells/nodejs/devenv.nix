{ pkgs, lib, ... }:

{
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_24;
    bun.enable = true;
    pnpm = {
      enable = true;
      package = pkgs.pnpm_9;
    };
  };

  packages = with pkgs; [
    eslint
    prettier
    typescript-go
    ts-node
    just
  ];
}
