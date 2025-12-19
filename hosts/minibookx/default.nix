{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf genAttrs;
in {
  networking.hostId = "56895d2b";

  hardware = {
    chuwi-minibook-x = {
      tabletMode.enable = true;
      autoDisplayRotation = {
        enable = true;
        commands = {
          normal = ''niri msg output "DSI-1" transform 90'';
          rightUp = ''niri msg output "DSI-1" transform normal'';
          bottomUp = ''niri msg output "DSI-1" transform 270'';
          leftUp = ''niri msg output "DSI-1" transform 180'';
        };
      };
    };
    i2c.enable = true;
  };

  programs.ssh = {
    extraConfig = ''
      Host sakura
        HostName 192.168.68.62
        Port 22
        User root
    '';
  };

  services = {
    syncoid = {
      commands."remote" = mkIf config.custom.syncoid.enable {
        source = "zroot/persist";
        target = "root@sakura:zfs-elements4T-1/media/minibookx";
        extraArgs = [
          "--no-sync-snap" # restrict itself to existing snapshots
          "--delete-target-snapshots" # snapshots which are missing on the source will be destroyed on the targe
        ];
        localSourceAllow = config.services.syncoid.localSourceAllow ++ ["mount"];
        localTargetAllow = config.services.syncoid.localTargetAllow ++ ["destroy"];
      };
    };

    syncthing = mkIf config.custom.syncthing.enable {
      key = config.sops.secrets."syncthing/minibookx-key".path;
      cert = config.sops.secrets."syncthing/minibookx-cert".path;

      settings = {
        devices = {
          "sakura" = {id = "VCKQ6LU-GNZWWFA-FGADQ44-PEWXCNN-2FT3YPC-C6XGTEY-G3APYSH-GO42PQG";};
        };
        folders = {
          "Documents" = {
            devices = ["sakura"];
          };
          "Music" = {
            devices = ["sakura"];
          };
          "MPD" = {
            devices = ["sakura"];
          };
          "Euphonica" = {
            devices = ["sakura"];
          };
          "Wallpapers" = {
            devices = ["sakura"];
          };
        };
      };
    };
  };

  custom = let
    enableList = [
      # "syncoid"
      # "syncthing"
    ];
    disableList = [
      "distrobox"
    ];
  in
    genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
