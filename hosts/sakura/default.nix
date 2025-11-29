{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf genAttrs;
in {
  services.syncthing = mkIf config.custom.syncthing.enable {
    key = config.sops.secrets."syncthing/sakura-key".path;
    cert = config.sops.secrets."syncthing/sakura-cert".path;

    settings = {
      devices = {
        "minibook" = {id = "IJOMYYL-OQPSRXW-FCJW6UB-NXBO2NW-ZZL2KFN-XVONDG2-E6KY2T4-LJMXWQ4";};
      };
      folders = {
        "Documents" = {
          devices = ["minibook"];
        };
        "Music" = {
          devices = ["minibook"];
        };
        "MPD" = {
          devices = ["minibook"];
        };
        "Euphonica" = {
          devices = ["minibook"];
        };
        "Wallpapers" = {
          devices = ["minibook"];
        };
      };
    };
  };

  custom = let
    enableList = [
      "logitech"
      "steam"
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
