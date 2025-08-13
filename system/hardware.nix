{
  lib,
  config,
  pkgs,
  isLaptop,
  ...
}: {
  options.custom = {
    touchpad.enable =
      lib.mkEnableOption "Touchpad support"
      // {
        default = isLaptop;
      };
  };

  config = {
    environment.systemPackages = with pkgs; [upower-notify];

    services = {
      # power management, conflict with TLP
      power-profiles-daemon.enable = config.hm.custom.battery.enable;
      upower = {
        enable = true;
      };
      libinput.enable = config.custom.touchpad.enable;
    };
  };
}
