{lib, ...}: {
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
        files =
          [
            "/etc/machine-id"

            # Required for SSH. If you have keys with different algorithms, then
            # you must also persist them here.
            "/etc/ssh/ssh_host_rsa_key"
            "/etc/ssh/ssh_host_rsa_key.pub"
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"

            "/var/lib/systemd/random-seed"
          ]
          ++ lib.unique cfg.persist.root.files;
        directories =
          [
            "/var/lib/fwupd"
            "/var/lib/power-profiles-daemon"
            "/var/lib/systemd/rfkill"
            "/var/lib/systemd/timers"

            "/var/log" # systemd journal is stored in /var/log/journal
            "/var/lib/nixos" # for persisting user uids and gids
          ]
          ++ lib.unique cfg.persist.root.directories;

        users.${user} = {
          files = lib.unique cfg.persist.home.files;
          directories =
            [
              ".pki"
              ".ssh"
              ".local/share/.gnupg"
              ".local/share/keyrings"

              "Documents"
              "Music"
              "Pictures"
              "Videos"
              "Projects"

              ".config/dconf"
            ]
            ++ lib.unique cfg.persist.home.directories;
        };
      };

      # cache are files that should be persisted, but not to snapshot
      # e.g. npm, cargo cache etc, that could always be redownloaded
      "/cache" = {
        hideMounts = true;
        files = lib.unique cfg.cache.root.files;
        directories =
          [
            "/var/lib/systemd/coredump"
          ]
          ++ lib.unique cfg.cache.root.directories;

        users.${user} = {
          files = lib.unique cfg.cache.home.files;
          directories =
            [
              "Downloads"
            ]
            ++ lib.unique cfg.cache.home.directories;
        };
      };
    };
  };
}
