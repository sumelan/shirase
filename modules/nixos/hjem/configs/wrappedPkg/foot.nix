{
  self,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) mkDefault;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) foot;
in {
  hjem.users.sumelan.rum = {
    programs.foot = {
      enable = mkDefault false;
      package = foot;
      server.enable = true;
    };
  };
}
