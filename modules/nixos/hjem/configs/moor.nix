{self, ...}: {
  flake.modules.nixos.default = {pkgs, ...}: let
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) moor;
  in {
    hj.packages = [moor];

    environment = {
      shellAliases = {
        less = "moor";
      };
      sessionVariables = {
        PAGER = "moor";
        SYSTEMD_PAGER = "moor";
        SYSTEMD_PAGERSECURE = "1";
      };
    };
  };
}
