{
  lib,
  config,
  ...
}:
{
  options.custom = with lib; {
    bluetooth.enable = mkEnableOption "Bluetooth" // {
      default = true;
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

    hm = hmCfg: {
      # control media player over bluetooth
      services.mpris-proxy.enable = true;
    };

    custom.persist = {
      root.directories = [ "/var/lib/bluetooth" ];
    };
  };
}
