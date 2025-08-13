{
  lib,
  isLaptop,
  ...
}: {
  services = lib.mkIf isLaptop {
    # power management, conflict with TLP
    power-profiles-daemon.enable = true;
    upower = {
      enable = true;
      usePercentageForPolicy = false;
      timeLow = 60 * 20;
      timeCritical = 60 * 10;
      timeAction = 60 * 2;
    };
    libinput.enable = true;
  };
}
