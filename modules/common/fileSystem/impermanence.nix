{
  config,
  lib,
  ...
}: let
  inherit (lib) unique;
in {
  flake.modules.nixos.default = {
    pkgs,
    user,
    ...
  }: {
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
        files = unique config.persist.rootFiles;
        directories = unique (
          [
            "/var/log" # systemd journal is stored in /var/log/journal
            "/var/lib/nixos" # for persisting user uids and gids
          ]
          ++ config.flake.persist.root.directories
        );

        users.${user} = {
          files = unique (config.flake.persist.home.files ++ config.hm.flake.persist.home.files);
          directories = unique (
            [
              "Projects"
              ".cache/dconf"
              ".config/dconf"
            ]
            ++ config.flake.persist.home.directories
            ++ config.hm.flake.persist.home.directories
          );
        };
      };

      # cache are files that should be persisted, but not to snapshot
      # e.g. npm, cargo cache etc, that could always be redownloaded
      "/cache" = {
        hideMounts = true;
        files = unique config.flake.cache.root.files;
        directories = unique config.flake.cache.root.directories;

        users.${user} = {
          files = unique config.hm.flake.cache.home.files;
          directories = unique config.hm.flake.cache.home.directories;
        };
      };
    };
  };
}
