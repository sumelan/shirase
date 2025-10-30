{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs) callPackage;
  mkNvf = extraModules: {
    host ? "acer",
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
  grub-nixos = callPackage ./grub-nixos {};

  helium = callPackage ./helium {};

  nvfNix = callPackage (mkNvf []) {};

  nvf = callPackage (mkNvf [
    # add extraModules here
    ./nvf/extraLang.nix
  ]) {};
}
