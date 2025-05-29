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
      percentageLow = 20;
      percentageCritical = 10;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };

    # touchpad support
    libinput.enable = true;
  };

  # SystemModule Options
  custom = {
    # style
    stylix = {
      colorTheme = "gruvbox-material-dark-soft";
      polarity = "dark";
    };

    # common
    btrbk.enable = true;
    distrobox.enable = true;

    # hardware
    logitech.enable = true;
  };
}
