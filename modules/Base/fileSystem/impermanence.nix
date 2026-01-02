{lib, ...}: let
  inherit (lib) unique;
in {
  flake.modules = {
    nixos.default = {
      config,
      pkgs,
      user,
      ...
    }: let
      cfg = config.custom;
      hmcfg = config.hm.custom;
    in {
      boot.initrd.systemd = {
        # enable stage-1 bootloader
        enable = true;
        services.rollback = {
          description = "Rollback ZFS root dataset to a pristine state";
          wantedBy = ["initrd.target"];
          after = ["zfs-import-zroot.service"];
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
          files = unique cfg.persist.root.files;
          directories = unique (
            [
              "/var/log" # systemd journal is stored in /var/log/journal
              "/var/lib/nixos" # for persisting user uids and gids
            ]
            ++ cfg.persist.root.directories
          );

          users.${user} = {
            files = unique (
              cfg.persist.home.files ++ hmcfg.persist.home.files
            );
            directories = unique (
              [
                "Projects"
                ".cache/dconf"
                ".config/dconf"
              ]
              ++ cfg.persist.home.directories
              ++ hmcfg.persist.home.directories
            );
          };
        };

        # cache are files that should be persisted, but not to snapshot
        # e.g. npm, cargo cache etc, that could always be redownloaded
        "/cache" = {
          hideMounts = true;
          files = unique cfg.cache.root.files;
          directories = unique cfg.cache.root.directories;

          users.${user} = {
            files = unique (
              cfg.cache.home.files ++ hmcfg.cache.home.files
            );
            directories = unique (
              cfg.cache.home.directories ++ hmcfg.cache.home.directories
            );
          };
        };
      };
    };
  };
}
