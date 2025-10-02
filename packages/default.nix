{
  pkgs,
  inputs,
  ...
}: let
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
  nvf = pkgs.callPackage (mkNvf [
    # add extraModules here
  ]) {};
}
