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

    audiobookshelf.enable = true;
    distrobox.enable = false;
  };
}
