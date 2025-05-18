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

    # specific
    hdds.enable = true;
    logitech.enable = true;
    opentabletdriver.enable = true;
    steam.enable = true;
    alvr.enable = false;
    qmk.enable = true;
    alsa.enable = true;

    # server
    audiobookshelf = {
      enable = true;
      nginx.enable = true;
    };
  };
}
