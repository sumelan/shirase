{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos."hosts/sakura" = {config, ...}: {
    imports = builtins.attrValues {
      inherit (flake.modules.nixos) default minisforum-um773se;
      inherit (flake.modules.nixos) kdeconnect steam;
      inherit (flake.modules.nixos) hdds qmk;
      inherit (flake.modules.nixos) audiobookshelf sops-nix syncoid syncthing;
      inherit (flake.modules.nixos) hjem-extended hjem-bluray hjem-cd;
    };

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
            "motorola razr 50" = {id = "3BSLI47-FLXIECF-S7QZWXG-ZXTMFFV-GLVVSLS-I3MYHPS-74GIRFU-5SVA6AO";};
          };
          folders = {
            "Music" = {
              devices = [
                "motorola razr 50"
              ];
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

      programs = {
        btop.rocmSupport = true;
        niri = {xwayland = true;};
      };
    };
  };
}
