{
  inputs,
  pkgs,
}: let
  mkNvf = modules:
    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs modules;
    }).neovim;

  mini = [
    ./config/config.nix
    ./modules/completion/blink.nix
    ./modules/languages/languages.nix
    ./modules/languages/nix.nix
    ./modules/navigation/neotree.nix
    ./modules/pickers/fzflua.nix
    ./modules/pickers/telescope.nix
    ./modules/visual/themes.nix
  ];
in
  mkNvf mini
