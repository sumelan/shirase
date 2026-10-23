{
  inputs,
  pkgs,
  extraModules ? [],
}: let
  mkNvf = modules:
    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs modules;
    }).neovim;

  full =
    [
      (inputs.import-tree ./config {})
      (inputs.import-tree ./modules {})
    ]
    ++ extraModules;
in
  mkNvf full
