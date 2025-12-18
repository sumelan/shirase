{
  lib,
  config,
  pkgs,
  user,
  ...
}: let
  inherit
    (lib)
    mkOption
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
    boot.initrd.systemd = {
      # enable stage-1 bootloader
      enable = true;
      services.rollback = {
        description = "Rollback ZFS root dataset to a pristine state";
        wantedBy = ["initrd.target"];
        after = ["zfs-import-system.service"];
        # Before mounting the system root (/sysroot) during the early boot process
        before = ["sysroot.mount"];
        path = [pkgs.zfs];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script =
          # sh
          ''
            zfs rollback -r zroot/root@blank
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
              "Projects"
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
