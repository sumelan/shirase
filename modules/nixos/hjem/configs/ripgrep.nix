{self, ...}: {
  flake.modules.nixos.default = {pkgs, ...}: let
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) ripgrep;
  in {
    hj.packages = [ripgrep];
  };
}
