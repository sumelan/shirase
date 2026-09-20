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
      services.rollback = lib.mkIf config.preservation.enable {
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

    preservation = {
      enable = false;
      preserveAt = {
        "/persist" = {
          commonMountOptions = [
            "x-gvfs-hide"
          ];
          files = lib.unique ([
              # Files that need to be persisted early, like `/etc/machine-id`.
              {
                file = "/etc/machine-id";
                inInitrd = true;
              }
              # Correct ownership and mode of SSH host keys.
              {
                file = "/etc/ssh/ssh_host_rsa_key";
                how = "symlink";
                configureParent = true;
              }
              {
                file = "/etc/ssh/ssh_host_ed25519_key";
                how = "symlink";
                configureParent = true;
              }
              # This file is expected to not exist before it is initialized.
              {
                file = "/var/lib/systemd/random-seed";
                how = "symlink";
                inInitrd = true;
              }
              "/etc/ssh/ssh_host_rsa_key.pub"
              "/etc/ssh/ssh_host_ed25519_key.pub"
            ]
            ++ cfg.persist.root.files);

          directories = lib.unique ([
              {
                directory = "/var/lib/fwupd";
                user = "fwupd-refresh";
                group = "fwupd-refresh";
              }

              "/var/lib/power-profiles-daemon"
              "/var/lib/systemd/rfkill"
              "/var/lib/systemd/timers"

              "/var/log" # systemd journal is stored in /var/log/journal
              "/var/lib/nixos" # for persisting user uids and gids
            ]
            ++ cfg.persist.root.directories);

          users.${user} = {
            commonMountOptions = [
              "x-gvfs-hide"
            ];
            files = lib.unique cfg.persist.home.files;
            directories = lib.unique ([
                {
                  directory = ".pki";
                  mode = "0700";
                }
                {
                  directory = ".ssh";
                  mode = "0700";
                }
                {
                  directory = ".local/share/.gnupg";
                  mode = "0700";
                }
                {
                  directory = ".local/share/keyrings";
                  mode = "0700";
                }

                "Documents"
                "Music"
                "Pictures"
                "Videos"
                "Projects"

                ".config/dconf"
              ]
              ++ cfg.persist.home.directories);
          };
        };

        # cache are files that should be persisted, but not to snapshot
        "/cache" = {
          commonMountOptions = [
            "x-gvfs-hide"
          ];
          files = lib.unique cfg.cache.root.files;
          directories = lib.unique ([
              "/var/lib/systemd/coredump"
            ]
            ++ cfg.cache.root.directories);
          users.${user} = {
            commonMountOptions = [
              "x-gvfs-hide"
            ];
            files = lib.unique cfg.cache.home.files;
            directories = lib.unique ([
                "Downloads"
              ]
              ++ cfg.cache.home.directories);
          };
        };
      };
    };

    # systemd-machine-id-commit.service would fail, but it is not relevant
    # in this specific setup for a persistent machine-id so we disable it
    #
    # see the firstboot example below for an alternative approach
    systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];

    # Create some directories with custom permissions.
    #
    # In this configuration the path `/home/butz/.local` is not an immediate parent
    # of any persisted file, so it would be created with the systemd-tmpfiles default
    # ownership `root:root` and mode `0755`. This would mean that the user `butz`
    # could not create other files or directories inside `/home/butz/.local`.
    #
    # Therefore systemd-tmpfiles is used to prepare such directories with
    # appropriate permissions.
    #
    # Note that immediate parent directories of persisted files can also be
    # configured with ownership and permissions from the `parent` settings if
    # `configureParent = true` is set for the file.
    systemd.tmpfiles.settings.preservation = let
      perm = {
        inherit user;
        group = "users";
        mode = "0755";
      };
    in {
      "/home/${user}/.config".d = perm;
      "/home/${user}/.cache".d = perm;
      "/home/${user}/.local".d = perm;
      "/home/${user}/.local/share".d = perm;
      "/home/${user}/.local/state".d = perm;
    };
  };
}
