_: {
  powerManagement.enable = true;

  services = {
    upower.enable = true;
    power-profiles-daemon.enable = true; # conflict with TLP

    # ssd
    fstrim.enable = true;
  };

  hardware.i2c.enable = true;
}
