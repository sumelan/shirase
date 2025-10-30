{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    singleton
    ;
in {
  options.custom = {
    bluetooth.enable =
      mkEnableOption "Bluetooth" // {default = true;};
  };

  config = mkIf config.custom.bluetooth.enable {
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

    hm = {
      # control media player over bluetooth
      services = {
        mpris-proxy.enable = true;
        blueman-applet.enable = true;
      };
      programs.niri.settings = {
        window-rules = [
          {
            matches = singleton {
              app-id = "^(.blueman-manager-wrapped)$";
            };
            open-floating = true;
          }
        ];
      };
    };

    custom.persist = {
      root.directories = ["/var/lib/bluetooth"];
    };
  };
}
