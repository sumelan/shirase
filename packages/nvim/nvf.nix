{
  inputs,
  pkgs,
  functions,
  hostName ? "omen",
  flake ? null,
}: let
  inherit (functions.import) tree;
  mkNvf = modules:
    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs modules;
      extraSpecialArgs = {inherit flake hostName;};
    }).neovim;

  full = [
    (tree ./config)
    (tree ./modules)
  ];
in
  mkNvf full
