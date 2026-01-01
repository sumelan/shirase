{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs) callPackage;
  mkNvf = extraModules: {
    host ? "minibookx",
    flakePath ? "",
  }:
    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules =
        [
          ./nvf
          ./nvf/keymaps.nix
        ]
        ++ extraModules;
      extraSpecialArgs = {inherit host flakePath;};
    }).neovim;
in {
  helium = callPackage ./helium {};

  nvfMini = callPackage (mkNvf []) {};
  nvf = callPackage (mkNvf [
    # add extraModules here
    ./nvf/lang.nix
    ./nvf/ui.nix
    ./nvf/util.nix
  ]) {};
}
