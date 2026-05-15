{lib, ...}: {
  flake.custom.hjemConfigs.pipewire = {
    config,
    pkgs,
    ...
  }: {
    hj = {
      rum = {
        services.easyeffects = {
          enable = true;
        };
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
            ExecStart = lib.getExe' pkgs.bluez "mpris-proxy";
          };
        };
      };
    };

    custom.fileSystem = {
      persist.home.directories = lib.optionals config.hj.rum.services.easyeffects.enable [
        ".config/easyeffects/db"
        # autoload local preset per devices
        ".local/share/easyeffects/autoload"
      ];
    };
  };
}
