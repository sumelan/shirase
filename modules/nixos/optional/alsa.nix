{
  lib,
  config,
  pkgs,
  user,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.alsa;
in {
  options.custom = {
    alsa.enable = mkEnableOption "Advanced Linux Sound Architecture";
  };

  config = mkIf cfg.enable {
    # ALSA settings
    environment.systemPackages = [pkgs.alsa-utils];
    users.users.${user}.extraGroups = ["audio"];

    custom.persist = {
      root.directories = [
        "/var/lib/alsa"
      ];
    };
  };
}
