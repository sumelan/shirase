{self, ...}: {
  flake.modules.nixos.gui = {pkgs, ...}: let
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) pqiv;
  in {
    hj.packages = [
      pqiv
      pkgs.swayimg
    ];
  };
}
