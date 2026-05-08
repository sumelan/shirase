{lib, ...}: let
  inherit (lib) getExe';
in {
  flake.modules.nixos = {
    bluetooth = {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Name = "Hello";
            ControllerMode = "dual";
            FastConnectable = "true";
            Enable = "Source,Sink,Media,Socket";
            Experimental = "true";
          };
          Policy = {
            AutoEnable = "true";
          };
        };
      };
      services.blueman.enable = true;

      custom.fileSystem = {
        persist.root.directories = ["/var/lib/bluetooth"];
      };
    };

    hjem-common = {pkgs, ...}: {
      hj = {
        systemd.services = {
          blueman-applet = {
            description = "Blueman applet";
            requires = ["tray.target"];
            after = ["graphical-session.target"] ++ ["tray.target"];
            partOf = ["graphical-session.target"];
            wantedBy = ["graphical-session.target"];

            serviceConfig = {
              ExecStart = getExe' pkgs.blueman "blueman-applet";
            };
          };

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
    };
  };
}
