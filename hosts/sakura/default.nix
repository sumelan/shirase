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
      hdds = {
        enable = true;
        wd = true;
      };
      btrbk = {
        enable = false;
        usb.enable = false;
      };
    }
    // genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
