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

    # touchpad support
    libinput.enable = true;
  };

  # SystemModule Options
  custom = {
    # style
    stylix.colorTheme = "gruvbox-dark-pale";

    alsa.enable = true;
    distrobox.enable = false;
  };
}
