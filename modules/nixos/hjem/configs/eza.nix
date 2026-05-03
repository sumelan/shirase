{self, ...}: {
  flake.modules.nixos.default = {pkgs, ...}: let
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) eza eza-tree;
  in {
    environment = {
      shellAliases = {
        t = "tree";
        cls = "command ls";
        ls = "eza";
        ll = "eza -l";
        la = "eza -a";
        lt = "eza --tree";
        lla = "eza -la";
      };
    };

    hj.packages = [eza eza-tree];
  };
}
