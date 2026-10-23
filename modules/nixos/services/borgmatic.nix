{pkgs, ...}: let
  inherit (pkgs.lib) mkForce;
in {
  services.borgmatic = {
    enable = true;
  };

  systemd = {
    services.borgmatic = {
      serviceConfig = {
        # zfs need /dev/zfs and /proc/self/mounts
        PrivateDevices = mkForce false; # show /dev/zfs
        PrivateMounts = mkForce false; # not hide /proc/self/mounts
        # if borgmatic's save path is blocked by ProtectSystem
        # ProtectSystem = lib.mkForce false;
        # or ReadWritePaths = [ "/var/lib/borgmatic" "/root/.config/borg" ];
        CapabilityBoundingSet = mkForce "~";

        StateDirectory = "borgmatic";
      };

      environment = {
        # `keys/` and `security/` default to subdirectories of the config dir
        BORG_CONFIG_DIR = "/var/lib/borgmatic/.config";
        # Borg relocates its cache via environment variables BORG_CACHE_DIR
        BORG_CACHE_DIR = "/var/lib/borgmatic/.cache";
      };
    };

    timers.borgmatic = {
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "10m";
      };
    };
  };

  custom.fileSystem = {
    persist.root.directories = [
      "/var/lib/borgmatic/borgmatic"
      "/var/lib/borgmatic/.config"
    ];
    cache.root.directories = [
      "/var/lib/borgmatic/.cache"
    ];
  };
}
