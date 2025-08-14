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
    };
    libinput.enable = true;
  };
}
