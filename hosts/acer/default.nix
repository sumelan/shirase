{ inputs, ... }:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-cpu-intel
  ];

  services = {
    # power management
    power-profiles-daemon.enable = true;
    upower = {
      enable = true;
      percentageLow = 30;
      percentageCritical = 15;
      percentageAction = 5;
      criticalPowerAction = "PowerOff";
    };

    # touchpad support
    libinput.enable = true;
  };

  # SystemModule Options
  custom = {
    # style
    stylix = {
      colorTheme = "nord";
      polarity = "dark";
    };

    # common
    btrbk.enable = true;
    distrobox.enable = true;
  };
}
