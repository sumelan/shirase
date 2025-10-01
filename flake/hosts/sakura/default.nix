{
  lib,
  inputs,
  ...
}: let
  inherit
    (lib)
    genAttrs
    ;
in {
  imports = builtins.attrValues {
    inherit
      (inputs.nixos-hardware.nixosModules)
      common-pc
      common-pc-ssd
      common-cpu-amd
      common-gpu-amd
      ;
  };

  networking.hostId = "a4b706c9";

  custom = let
    enableList = [
      "alsa"
      "hdds"
      "syncoid"
    ];
    disableList = [
      "audiobookshelf"
      "distrobox"
      "steam"
    ];
  in
    genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
