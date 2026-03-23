{lib, ...}: let
  inherit (lib) getExe';
in {
  flake.modules = {
    nixos.hardware = {
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

    homeManager.default = {pkgs, ...}: {
      systemd.user.services = {
        blueman-applet = {
          Unit = {
            Description = "Blueman applet";
            Requires = ["tray.target"];
            After = ["graphical-session.target"] ++ ["tray.target"];
            PartOf = ["graphical-session.target"];
          };

          Install.WantedBy = ["graphical-session.target"];

          Service = {
            ExecStart = getExe' pkgs.blueman "blueman-applet";
          };
        };
        # mpris user service to control media player over bluetooth
        mpris-proxy = {
          Unit = {
            Description = "Proxy forwarding Bluetooth MIDI controls via MPRIS2 to control media players";
            BindsTo = ["bluetooth.target"];
            After = ["bluetooth.target"];
          };

          Install.WantedBy = ["bluetooth.target"];

          Service = {
            Type = "simple";
            ExecStart = getExe' pkgs.bluez "mpris-proxy";
          };
        };
      };
    };
  };
}
