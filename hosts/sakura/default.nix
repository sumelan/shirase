{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf genAttrs;
in {
  # FIXME: add networking.hostID.
  networking.hostId = "4ca77dfb";

  services = {
    syncthing = mkIf config.custom.syncthing.enable {
      key = config.sops.secrets."syncthing/sakura-key".path;
      cert = config.sops.secrets."syncthing/sakura-cert".path;

      settings = {
        devices = {
          "minibookx" = {id = "IJOMYYL-OQPSRXW-FCJW6UB-NXBO2NW-ZZL2KFN-XVONDG2-E6KY2T4-LJMXWQ4";};
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
      #  "syncthing"
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
        enable = false;
        westernDigital = true;
        ironWolf = true;
      };
    }
    // genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
