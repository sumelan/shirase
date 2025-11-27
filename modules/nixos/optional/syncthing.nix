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

        guiPasswordFile = config.sops.secrets."syncthing/gui-password".path;

        settings.gui = {
          inherit user;
          theme = "dark";
        };
      }
      # client only settings
      (optionalAttrs (config.custom.syncthing.device == "client") {
        key = config.sops.secrets."syncthing/key-1".path;
        cert = config.sops.secrets."syncthing/cert-1".path;
        settings = {
          devices = {
            "minibook" = {id = "VRJEHDZ-I5FAPC2-OAJRAZ2-LHTI5JJ-ZEQGFMK-4EH2JCD-LHQVOT4-L32NWQL";};
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
      (optionalAttrs (config.custom.syncthing.device == "target") {
        key = config.sops.secrets."syncthing/key-2".path;
        cert = config.sops.secrets."syncthing/cert-2".path;
        settings = {
          devices = {
            "sakura" = {id = "2BUKV63-UG6GGS7-22YYLZI-CAGCBXX-CRD46AJ-GFQXMKN-RCISUOJ-XXVBXAE";};
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
