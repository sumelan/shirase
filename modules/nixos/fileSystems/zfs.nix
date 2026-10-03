_: {
  flake.modules.nixos.core = {pkgs, ...}: let
    mkZfs = device: {
      inherit device;
      fsType = "zfs";
      neededForBoot = true;
    };
  in {
    boot = {
      kernelModules = ["zfs"];
      supportedFilesystems = ["zfs"];
      zfs = {
        devNodes = "/dev/disk/by-partuuid";

        package = pkgs.zfs_unstable;

        # WARN: a mismatched host ID will prevent ZFS from importing the pool,
        # but you can override that with a force import
        # forceImportAll = true;

        requestEncryptionCredentials = true;
        forceImportRoot = false;
      };
    };

    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    # INFO: zfs datasets are created via install.sh
    fileSystems = {
      "/" = mkZfs "zroot/root";
      "/nix" = mkZfs "zroot/nix";
      "/persist" = mkZfs "zroot/persist";
      # cache are files that should be persisted, but not to snapshot
      "/cache" = mkZfs "zroot/cache";
    };

    systemd.services = {
      # https://github.com/openzfs/zfs/issues/10891
      systemd-udev-settle.enable = false;
    };

    services.sanoid = {
      enable = true;
      datasets = {
        "zroot/persist" = {
          hourly = 50;
          daily = 15;
          weekly = 3;
          monthly = 1;
        };
      };
    };
  };
}
