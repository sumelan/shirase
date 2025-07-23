{ inputs, ... }:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-pc-ssd
    common-cpu-amd
    common-gpu-amd
  ];

  # SystemModule Options
  custom = {
    stylix.colorTheme = "catppuccin-frappe";

    btrbk.enable = true;
    distrobox.enable = false;
  };
}
