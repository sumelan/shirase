{
  pkgs,
  inputs,
  ...
}: {
  nvf = pkgs.callPackage (
    {
      host ? "acer",
      flakePath ? "",
    }:
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [./nvf];
        extraSpecialArgs = {inherit host flakePath;};
      }).neovim
  ) {};
}
