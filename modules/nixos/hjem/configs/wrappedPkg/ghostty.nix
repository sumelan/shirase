{
  self,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) mkDefault;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) ghostty;
in {
  hjem.users.sumelan.rum = {
    programs.ghostty = {
      enable = mkDefault false;
      package = ghostty;
      systemd.enable = true;
    };
  };
}
