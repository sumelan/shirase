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
    alvr.enable = true;
    audiobookshelf = {
      enable = true;
      nginx.enable = true;
    };
    distrobox.enable = true;
    hdds.enable = true;
    steam.enable = true;
    qmk.enable = true;
    usb-audio.enable = true;
  };
}
