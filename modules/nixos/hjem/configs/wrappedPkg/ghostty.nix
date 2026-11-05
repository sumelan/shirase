{
  self,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) mkDefault;
in {
  hjem.users.sumelan.rum = {
    programs.ghostty = {
      enable = mkDefault false;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.ghostty;
      systemd.enable = true;
    };
  };
}
