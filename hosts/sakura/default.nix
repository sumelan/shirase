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
    hdds.enable = true;
    distrobox.enable = true;
    opentabletdriver.enable = true;
  };
}
