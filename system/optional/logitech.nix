{
  lib,
  config,
  ...
}: {
  options.custom = {
    logitech = {
      enable = lib.mkEnableOption "Whether to enable support for Logitech Wireless Devices";
    };
  };

  config = lib.mkIf config.custom.logitech.enable {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

    hm.programs.niri.settings.spawn-at-startup = [
      {
        command = ["solaar" "-w" "hide"];
      }
    ];
  };
}
