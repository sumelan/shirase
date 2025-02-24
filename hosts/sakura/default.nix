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
    backup = {
      enable = true;
      repo = "pv7d7r9m@pv7d7r9m.repo.borgbase.com:repo";
    };
    agenix.enable = false;
    distrobox.enable = true;
    qmk.enable = true;
    opentabletdriver.enable = true;
  };
}
