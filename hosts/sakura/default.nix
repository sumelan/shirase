{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf genAttrs;
in {
  networking.hostId = "b5e8f0be";

  services = {
    syncthing = mkIf config.custom.syncthing.enable {
      key = config.sops.secrets."syncthing/sakura-key".path;
      cert = config.sops.secrets."syncthing/sakura-cert".path;

      settings = {
        devices = {
          "minibookx" = {id = "LTAE56R-6ARZAXL-JK4KL6B-IHVTITS-AEL3TCQ-JR4ZNQQ-52QHVU2-7UU7SQI";};
        };
        folders = {
          "Documents" = {
            devices = ["minibookx"];
          };
          "Music" = {
            devices = ["minibookx"];
          };
          "MPD" = {
            devices = ["minibookx"];
          };
          "Euphonica" = {
            devices = ["minibookx"];
          };
          "Wallpapers" = {
            devices = ["minibookx"];
          };
        };
      };
    };
  };

  custom = let
    enableList = [
      "logitech"
      "steam"
      #  "syncoid"
      "syncthing"
      "qmk"
    ];
    disableList = [
      "audiobookshelf"
      "distrobox"
      "vr"
    ];
  in
    {
      hdds = {
        enable = true;
        westernDigital = true;
        ironWolf = true;
      };
    }
    // genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
