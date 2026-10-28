{
  self,
  inputs,
  pkgs,
  hostName ? "omen",
  flake ? null,
}: let
  mkNvf = modules:
    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs modules;
      extraSpecialArgs = {inherit self flake hostName;};
    }).neovim;

  full = [
    (inputs.import-tree ./config)
    (inputs.import-tree ./modules)
  ];
in
  mkNvf full
