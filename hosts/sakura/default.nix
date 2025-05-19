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
    stylix = {
      colorTheme = "catppuccin-frappe";
      polarity = "dark";
    };

    # common
    btrbk.enable = true;
    distrobox.enable = true;

    # hardware
    hdds.enable = true;
    alsa.enable = true;
    logitech.enable = true;
    qmk.enable = true;
    opentabletdriver.enable = true;

    # steam
    steam.enable = false;

    # server
    audiobookshelf = {
      enable = true;
      nginx.enable = true;
    };
  };
}
