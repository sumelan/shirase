{
  lib,
  isLaptop,
  ...
}: {
  services = lib.mkMerge [
    # power management
    {
      upower.enable = true;
      power-profiles-daemon.enable = true; # conflict with TLP
    }
    (lib.mkIf isLaptop {
      libinput.enable = true;
    })
  ];
}
