# hardware related options that are referenced within home-manager need to be defined here
# for home-manager to be able to access them
{
  lib,
  isLaptop,
  ...
}: {
  options.custom = {
    backlight.enable =
      lib.mkEnableOption "Backlight"
      // {
        default = isLaptop;
      };
    battery.enable =
      lib.mkEnableOption "Battery"
      // {
        default = isLaptop;
      };
    wifi.enable =
      lib.mkEnableOption "Wifi"
      // {
        default = isLaptop;
      };
  };
}
