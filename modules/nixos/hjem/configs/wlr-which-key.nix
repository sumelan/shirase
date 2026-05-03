{self, ...}: {
  flake.modules.nixos.gui = {pkgs, ...}: let
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) wlr-which-key;
  in {
    hj.packages = [wlr-which-key];
  };
}
