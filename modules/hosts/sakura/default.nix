{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos."hosts/sakura" = {
    config,
    pkgs,
    ...
  }: {
    imports = with flake.modules.nixos;
      [minisforum-um773se]
      ++ [default mpd gui steam]
      ++ [hdds logitech qmk]
      ++ [audiobookshelf sops-nix syncoid syncthing]
      ++ [
        bluray
        cd
        ebook
        euphonica
        kdeconnect
        obs
        protonapp
        zen
      ];

    networking.hostId = "b5e8f0be";

    services = {
      syncoid = {
        commands."zusb" = {
          source = "zroot/persist";
          target = "zusb-iw2T/backups/sakura";
          extraArgs = [
            "--no-sync-snap" # restrict itself to existing snapshots
            "--delete-target-snapshots" # snapshots which are missing on the source will be destroyed on the targe
          ];
          localSourceAllow = config.services.syncoid.localSourceAllow ++ ["mount"];
          localTargetAllow = config.services.syncoid.localTargetAllow ++ ["destroy"];
        };
      };

      syncthing = {
        key = config.sops.secrets."syncthing/sakura-key".path;
        cert = config.sops.secrets."syncthing/sakura-cert".path;
        settings = {
          devices = {
            "minibookx" = {id = "LTAE56R-6ARZAXL-JK4KL6B-IHVTITS-AEL3TCQ-JR4ZNQQ-52QHVU2-7UU7SQI";};
            "motorola razr 50" = {id = "3BSLI47-FLXIECF-S7QZWXG-ZXTMFFV-GLVVSLS-I3MYHPS-74GIRFU-5SVA6AO";};
          };
          folders = {
            "Documents" = {
              devices = ["minibookx"];
            };
            "Music" = {
              devices = [
                "minibookx"
                "motorola razr 50"
              ];
            };
            "Pictures" = {
              devices = ["minibookx"];
            };
            "Videos" = {
              devices = ["minibookx"];
            };
            "MPD" = {
              devices = ["minibookx"];
            };
            "Youtube" = {
              devices = ["minibookx"];
            };
            "Euphonica" = {
              devices = ["minibookx"];
            };
          };
        };
      };
    };

    custom = {
      hardware = {
        monitors = {
          "HDMI-A-1" = {
            isMain = true;
            scale = 1.5;
            mode = {
              width = 3840;
              height = 2160;
              refresh = 60.0;
            };
            position = {
              x = 0;
              y = 0;
            };
            rotation = 0;
          };
        };

        hdds = {
          westernDigital = true;
          ironWolf = true;
        };
      };

      # unhinted font: for high resolution screen
      fonts.packages = [pkgs.maple-mono.NF-unhinted];

      programs = {
        btop.rocmSupport = true;
        niri = {xwayland = true;};
      };
    };
  };
}
