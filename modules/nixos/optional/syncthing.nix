{
  lib,
  config,
  user,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    mkMerge
    optionalAttrs
    ;
  inherit (lib.types) str;
in {
  options.custom = {
    syncthing = {
      enable = mkEnableOption "syncthing";
      device = mkOption {
        type = str;
        description = "client or target";
        default = "";
      };
    };
  };

  config = mkIf config.custom.syncthing.enable {
    # port 8384  is the default port to allow access from the network
    networking.firewall.allowedTCPPorts = [8384];

    services.syncthing = mkMerge [
      # common settings
      {
        enable = true;
        openDefaultPorts = true;

        # NOTE: by default, syncthing creates user `syncthing` so no perm outside `/var/lib/syncthing`
        inherit user;
        inherit (config.users.users.${user}) group;

        configDir = "/home/${user}/.config/syncthing";
        dataDir = "/home/${user}/.local/state/syncthing";

        guiPasswordFile = config.sops.secrets.syncthing-gui-password.path;

        settings.gui = {
          inherit user;
          theme = "dark";
        };
      }
      # client only settings
      (optionalAttrs (config.custom.syncthing.device == "client") {
        # need to be readable by `user`
        key = config.sops.secrets.syncthing-key.path;
        cert = config.sops.secrets.syncthing-cert.path;

        settings = {
          devices = {
            "minibook" = {id = "KZZDUA6-JCXJCD7-L5NZPVK-P2XFY72-GZMJX6U-C4KAWRP-HON5V5R-SMAK4QQ";};
          };
          folders = {
            "Documents" = {
              path = "/home/${user}/Documents";
              devices = ["minibook"];
            };
            "Music" = {
              path = "/home/${user}/Music";
              devices = ["minibook"];
            };
            "Playlist" = {
              path = "/home/${user}/.local/share/mpd/playlists";
              devices = ["minibook"];
            };
            "Wallpapers" = {
              path = "/home/${user}/Pictures/Wallpapers";
              devices = ["minibook"];
            };
          };
        };
      })
    ];

    custom.persist = {
      home.directories = [
        ".config/syncthing"
        ".local/state/syncthing"
      ];
    };
  };
}
