{lib, ...}: let
  inherit (lib) genAttrs;
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
        enable = false;
        usb.enable = false;
      };
      hdds = {
        enable = false;
        wd.enable = false;
        ironwolf.enable = false;
      };
    }
    // genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
