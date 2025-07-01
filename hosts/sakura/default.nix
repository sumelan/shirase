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
    # style
    stylix.colorTheme = "gruvbox-material-dark-soft";

    # common
    btrbk.enable = true;
    distrobox.enable = false;

    # hardware
    hdds.enable = true;
    alsa.enable = true;
    logitech.enable = true;

    # steam
    steam.enable = false;

    # server
    audiobookshelf.enable = true;
  };
}
