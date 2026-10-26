{
  self,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) mkDefault;
in {
  hjem.users.sumelan.rum = {
    programs.ghostty = {
      enable = mkDefault true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.ghostty;
      systemd.enable = true;
    };
  };

  environment.sessionVariables = {
    TERMINAL = "ghostty";
  };
}
