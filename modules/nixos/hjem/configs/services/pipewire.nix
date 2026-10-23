{
  config,
  pkgs,
  ...
}: let
  inherit
    (pkgs.lib)
    getExe'
    mkIf
    ;
  cfg = config.hjem.users.sumelan.rum;
in {
  hjem.users.sumelan = {
    rum = {
      services.easyeffects.enable = true;
    };

    packages = [pkgs.pwvucontrol];

    systemd.services = {
      # mpris user service to control media player over bluetooth
      mpris-proxy = {
        description = "Proxy forwarding Bluetooth MIDI controls via MPRIS2 to control media players";
        bindsTo = ["bluetooth.target"];
        after = ["bluetooth.target"];
        wantedBy = ["bluetooth.target"];

        serviceConfig = {
          Type = "simple";
          ExecStart = getExe' pkgs.bluez "mpris-proxy";
        };
      };
    };
  };

  custom.fileSystem = {
    persist.home.directories = mkIf cfg.services.easyeffects.enable [
      ".config/easyeffects/db"
      # autoload local preset per devices
      ".local/share/easyeffects/autoload"
    ];
  };
}
