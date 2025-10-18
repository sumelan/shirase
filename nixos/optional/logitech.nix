{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    logitech = {
      enable = mkEnableOption "Whether to enable support for Logitech Wireless Devices";
    };
  };

  config = mkIf config.custom.logitech.enable {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

    hm.programs.niri.settings.spawn-at-startup = [
      {
        argv = ["solaar" "-w" "hide"];
      }
    ];
  };
}
