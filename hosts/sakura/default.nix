{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
  ];

  # SystemModule Options.
  custom = {
    distrobox.enable = true;
    opentabletdriver.enable = true;
  };
}
