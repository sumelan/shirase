{
  self,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) mkDefault;
in {
  hjem.users.sumelan.rum = {
    programs.foot = {
      enable = mkDefault false;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.foot;
      server.enable = true;
    };
  };
}
