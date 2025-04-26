{
  lib,
  config,
  ...
}:
{
  options.custom = with lib; {
    logitech = {
      enable = mkEnableOption "Whether to enable support for Logitech Wireless Devices";
    };
  };

  config = lib.mkIf config.custom.logitech.enable {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
