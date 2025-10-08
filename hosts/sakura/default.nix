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
