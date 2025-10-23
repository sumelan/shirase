{
  pkgs,
  inputs,
  ...
}: let
  inherit (pkgs) callPackage;
  mkNvf = extraModules: {
    host ? "acer",
    flakePath ? "",
  }:
    (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [./nvf] ++ extraModules;
      extraSpecialArgs = {inherit host flakePath;};
    }).neovim;
in {
  grub-nixos = callPackage ./grub-nixos {};

  helium = callPackage ./helium {};

  nvf = callPackage (mkNvf [
    # add extraModules here
  ]) {};
}
