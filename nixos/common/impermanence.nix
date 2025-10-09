{
  lib,
  config,
  user,
  ...
}: let
  inherit
    (lib)
    mkOption
    mkAfter
    unique
    assertMsg
    any
    hasPrefix
    ;
  inherit (lib.types) listOf str;

  cfg = config.custom.persist;
  hmPersistCfg = config.hm.custom.persist;
  assertNoHomeDirs = paths:
    assert (assertMsg (!any (hasPrefix "/home") paths) "/home used in a root persist!"); paths;
in {
  options.custom = {
    persist = {
      root = {
        directories = mkOption {
          type = listOf str;
          default = [];
          apply = assertNoHomeDirs;
          description = "Directories to persist in root filesystem";
        };
        files = mkOption {
          type = listOf str;
          default = [];
          apply = assertNoHomeDirs;
          description = "Files to persist in root filesystem";
        };
        cache = {
          directories = mkOption {
            type = listOf str;
            default = [];
            apply = assertNoHomeDirs;
            description = "Directories to persist, but not to snapshot";
          };
          files = mkOption {
            type = listOf str;
            default = [];
            apply = assertNoHomeDirs;
            description = "Files to persist, but not to snapshot";
          };
        };
      };
      home = {
        directories = mkOption {
          type = listOf str;
          default = [];
          description = "Directories to persist in home directory";
        };
        files = mkOption {
          type = listOf str;
          default = [];
          description = "Files to persist in home directory";
        };
      };
    };
  };

  config = {
    boot = {
      # clear /tmp on boot
      tmp.cleanOnBoot = true;
      # wipe /root at each boot and back to blank state
      initrd = {
        enable = true;
        supportedFilesystems = ["btrfs"];
        postResumeCommands =
          mkAfter
          # sh
          ''
            mkdir -p /mnt

            # mount btrfs root(/) to /mnt and manipulate btrfs subvolume
            mount -o subvol=/ /dev/disk/by-label/NIXOS /mnt

            # show and remove subvolumes below /mnt/root
            btrfs subvolume list -o /mnt/root |
            cut -f9 -d' ' |
            while read subvolume; do
                echo "deleting /$subvolume subvolume..."
                btrfs subvolume delete "/mnt/$subvolume"
            done &&
            echo "deleting /root subvolume..." &&
            btrfs subvolume delete /mnt/root

            echo "restoring blank /root subvolume..."
            btrfs subvolume snapshot /mnt/root-blank /mnt/root

            umount /mnt
          '';
      };
    };

    # setup persistence
    environment.persistence = {
      "/persist" = {
        hideMounts = true;
        files = unique cfg.root.files;
        directories = unique (
          [
            "/var/log" # systemd journal is stored in /var/log/journal
            "/var/lib/nixos" # for persisting user uids and gids
          ]
          ++ cfg.root.directories
        );

        users.${user} = {
          files = unique (cfg.home.files ++ hmPersistCfg.home.files);
          directories = unique (
            [
              "projects"
              ".cache/dconf"
              ".config/dconf"
            ]
            ++ cfg.home.directories
            ++ hmPersistCfg.home.directories
          );
        };
      };

      # cache are files that should be persisted, but not to snapshot
      # e.g. npm, cargo cache etc, that could always be redownloaded
      "/cache" = {
        hideMounts = true;
        files = unique cfg.root.cache.files;
        directories = unique cfg.root.cache.directories;

        users.${user} = {
          files = unique hmPersistCfg.home.cache.files;
          directories = unique hmPersistCfg.home.cache.directories;
        };
      };
    };
  };
}
