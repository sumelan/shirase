{
  lib,
  config,
  isLaptop,
  ...
}:
{
  options.custom = {
    touchpad.enable = lib.mkEnableOption "Touchpad support" // {
      default = isLaptop;
    };
  };

  config = {
    services = {
      # power management, conflict with TLP
      power-profiles-daemon.enable = config.hm.custom.battery.enable;
      libinput.enable = config.custom.touchpad.enable;
    };
  };
}
