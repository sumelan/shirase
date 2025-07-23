{
  lib,
  config,
  isLaptop,
  ...
}:
{
  options.custom = with lib; {
    bluetooth.enable = mkEnableOption "Bluetooth" // {
      default = isLaptop;
    };
  };

  config = lib.mkIf config.custom.bluetooth.enable {
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
            matches = lib.singleton {
              app-id = "^(.blueman-manager-wrapped)$";
            };
            open-floating = true;
          }
        ];
      };
    };

    custom.persist = {
      root.directories = [ "/var/lib/bluetooth" ];
    };
  };
}
