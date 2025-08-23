{
  pkgs,
  inputs,
  ...
}: {
  colloid-pastel-cursors = pkgs.callPackage ./colloid-pastel-cursors {};
  colloid-pastel-icons = pkgs.callPackage ./colloid-pastel-icons {};

  neovim-sumelan = pkgs.callPackage (
    {
      host ? "acer",
      flakePath ? "",
    }:
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [./neovim-sumelan];
        extraSpecialArgs = {inherit host flakePath;};
      }).neovim
  ) {};
}
