{ inputs, ... }:
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-pc-ssd
    common-cpu-amd
    common-gpu-amd
  ];

  # SystemModule Options.
  custom = {
    alvr.enable = false;
    audiobookshelf = {
      enable = true;
      nginx.enable = true;
    };
    btrbk.enable = true;
    distrobox.enable = true;
    hdds.enable = true;
    opentabletdriver.enable = true;
    steam.enable = false;
    qmk.enable = true;
    usb-audio.enable = true;
  };
}
