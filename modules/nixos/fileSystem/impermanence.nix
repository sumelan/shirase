{lib, ...}: let
  inherit (lib) unique;
in {
  flake.modules.nixos.core = {
    config,
    user,
    ...
  }: let
    cfg = config.custom.fileSystem;
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
        path = [config.boot.zfs.package];
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
          files = unique cfg.persist.home.files;
          directories = unique (
            [
              "Documents"
              "Music"
              "Pictures"
              "Videos"
              "Projects"
            ]
            ++ cfg.persist.home.directories
          );
        };
      };

      # cache are files that should be persisted, but not to snapshot
      # e.g. npm, cargo cache etc, that could always be redownloaded
      "/cache" = {
        hideMounts = true;
        files = unique cfg.cache.root.files;
        directories = ["/var/lib/systemd/coredump"] ++ unique cfg.cache.root.directories;

        users.${user} = {
          files = unique cfg.cache.home.files;
          directories = unique (
            [
              "Downloads"
            ]
            ++ cfg.cache.home.directories
          );
        };
      };
    };
  };
}
