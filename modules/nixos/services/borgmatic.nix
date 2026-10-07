{lib, ...}: {
  flake.modules.nixos.borgmatic = _: {
    services.borgmatic = {
      enable = true;
    };

    systemd = {
      services.borgmatic.serviceConfig = {
        # zfs need /dev/zfs and /proc/self/mounts
        PrivateDevices = lib.mkForce false; # show /dev/zfs
        PrivateMounts = lib.mkForce false; # not hide /proc/self/mounts
        # if borgmatic's save path is blocked by ProtectSystem
        # ProtectSystem = lib.mkForce false;
        # or ReadWritePaths = [ "/var/lib/borgmatic" "/root/.config/borg" ];
        CapabilityBoundingSet = lib.mkForce "~";
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
