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
        wd = false;
        ironwolf = true;
      };
      btrbk = {
        enable = true;
        usb.enable = true;
      };
    }
    // genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
