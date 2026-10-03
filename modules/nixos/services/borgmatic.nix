{lib, ...}: {
  flake.modules.nixos.borgmatic = {
    config,
    pkgs,
    ...
  }: {
    security.nix-secrets.secrets = lib.mkIf config.services.borgmatic.enable {
      "borgmatic/encryption" = {};
    };

    services.borgmatic = {
      enable = true;
      configurations = let
        settings = {
          checks = [
            {
              name = "repository";
              frequency = "2 weeks";
            }
            {
              name = "archives";
              frequency = "4 weeks";
            }
            {
              name = "data";
              frequency = "6 weeks";
            }
            {
              name = "extract";
              frequency = "6 weeks";
            }
          ];

          keep_daily = 7;
          keep_weekly = 4;
          keep_monthly = 6;

          ssh_command = "ssh -i /root/.ssh/id_ed25519";

          encryption_passcommand =
            # sh
            ''${lib.getExe' pkgs.uutils-coreutils-noprefix.out "cat"} ${config.security.nix-secrets.secrets."borgmatic/encryption".path}'';

          zfs = {
            zfs_command = lib.getExe config.boot.zfs.package;
            mount_command = lib.getExe' pkgs.unixtools.util-linux.out "mount";
            umount_command = lib.getExe' pkgs.unixtools.util-linux.out "umount";
          };
        };
      in {
        backups =
          {
            source_directories = [
              "/backups"
            ];
            repositories = [
              {
                label = "borgbase";
                path = "ssh://l78rf7w1@l78rf7w1.repo.borgbase.com/./repo";
              }
            ];
          }
          // settings;

        media =
          {
            source_directories = [
              "/media"
            ];
            repositories = [
              {
                label = "borgbase";
                path = "ssh://huyey7vy@huyey7vy.repo.borgbase.com/./repo";
              }
            ];
          }
          // settings;
      };
    };

    systemd = {
      services.borgmatic.serviceConfig = {
        # zfs need /dev/zfs and /proc/self/mounts
        PrivateDevices = lib.mkForce false; # show /dev/zfs
        PrivateMounts = lib.mkForce false; # not hide /proc/self/mounts
        # if borgmatic's save path is blocked by ProtectSystem
        # ProtectSystem = lib.mkForce false;
        # or ReadWritePaths = [ "/var/lib/borgmatic" "/root/.config/borg" ];
        CapabilityBoundingSet = lib.mkForce "";
      };
      timers.borgmatic = {
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "10m";
        };
      };
    };
  };
}
