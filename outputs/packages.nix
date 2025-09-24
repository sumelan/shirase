{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    mkNvf = extraModules: {
      host ? "acer",
      flakePath ? "",
    }:
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [../flake/packages/nvf] ++ extraModules;
        extraSpecialArgs = {inherit host flakePath;};
      }).neovim;
  in {
    packages = {
      nvf = pkgs.callPackage (mkNvf []) {};
      everforest-cursors = pkgs.callPackage ../flake/packages/everforest-cursors {};
    };
  };
}
