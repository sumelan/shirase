{lib, ...}: let
  inherit
    (lib)
    genAttrs
    ;
in {
  custom = let
    enableList = [
      "alsa"
      "logitech"
    ];
    disableList = [
      "audiobookshelf"
      "distrobox"
      "steam"
    ];
  in
    {
      btrbk = {
        enable = true;
        usb.enable = false;
      };
    }
    // genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
