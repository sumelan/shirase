{self, ...}: {
  flake.modules.nixos.foot = {pkgs, ...}: let
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) foot;
  in {
    hj.packages = [foot];
  };
}
