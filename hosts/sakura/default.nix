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
        enable = true;
        westernDigital.enable = true;
        ironWolf.enable = true;
      };
    }
    // genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
