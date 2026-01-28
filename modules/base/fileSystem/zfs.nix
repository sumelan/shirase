_: {
  flake.modules.nixos.default = {
    config,
    pkgs,
    ...
  }: {
    boot = {
      kernelModules = ["zfs"];
      supportedFilesystems = ["zfs"];
      zfs = {
        devNodes =
          if config.hardware.cpu.intel.updateMicrocode
          then "/dev/disk/by-id"
          else "/dev/disk/by-partuuid";

        package = pkgs.zfs_2_4;
        # a mismatched host ID will prevent ZFS from importing the pool, but you can override that with a force import
        # forceImportAll = true;
        requestEncryptionCredentials = true;
      };
    };

    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    # standardized filesystem layout
    # NOTE: zfs datasets are created via install.sh
    fileSystems = {
      "/" = {
        device = "zroot/root";
        fsType = "zfs";
        neededForBoot = true;
      };

      "/nix" = {
        device = "zroot/nix";
        fsType = "zfs";
        neededForBoot = true;
      };

      "/persist" = {
        device = "zroot/persist";
        fsType = "zfs";
        neededForBoot = true;
      };

      # cache are files that should be persisted, but not to snapshot
      # e.g. npm, cargo cache etc, that could always be redownloaded
      "/cache" = {
        device = "zroot/cache";
        fsType = "zfs";
        neededForBoot = true;
      };
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
