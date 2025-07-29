{
  lib,
  config,
  pkgs,
  user,
  ...
}:
# NOTE:spotify refuse to play when above 192 kHz
let
  cfg = config.custom.alsa;
in
{
  options.custom = {
    alsa.enable = lib.mkEnableOption "Advanced Linux Sound Architecture" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # ALSA settings
    environment.systemPackages = with pkgs; [ alsa-utils ];
    users.users.${user}.extraGroups = [ "audio" ];

    custom.persist = {
      root.directories = [
        "/var/lib/alsa"
      ];
    };
  };
}
