{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-intel
  ];

  # Laptop Modules.
  services = {
    power-profiles-daemon.enable = true;
    # touchpad support
    libinput.enable = true;
  };

  # SystemModule Options
  custom = {
    btrbk.enable = true;
    distrobox.enable = true;
  };
}
