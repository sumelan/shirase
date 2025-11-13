{lib, ...}: let
  inherit (lib) genAttrs;
in {
  custom = let
    enableList = [
      "alsa-util"
      "logitech"
      "steam"
      "qmk"
    ];
    disableList = [
      "audiobookshelf"
      "distrobox"
      "vr"
    ];
  in
    {
      btrbk = {
        enable = true;
        usb.enable = true;
      };
      hdds = {
        enable = true;
        westernDigital.enable = true;
        ironWolf.enable = true;
      };
    }
    // genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
