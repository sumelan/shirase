{ inputs, ... }:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-cpu-intel
  ];

  services = {
    # power management
    power-profiles-daemon.enable = true; # conflict with TLP
    upower = {
      enable = true;
      percentageLow = 30;
      percentageCritical = 10;
      percentageAction = 5;
      criticalPowerAction = "PowerOff";
    };

    # touchpad support
    libinput.enable = true;
  };

  # SystemModule Options
  custom = {
    maomaowm.enable = true;
    # style
    stylix.colorTheme = "catppuccin-frappe";

    # common
    btrbk.enable = true;
    distrobox.enable = false;
  };
}
