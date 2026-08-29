{lib, ...}: {
  flake.modules.nixos.core = {
    config,
    pkgs,
    ...
  }: {
    boot = let
      # use the latest ZFS-compatible Kernel
      # https://wiki.nixos.org/wiki/ZFS
      zfsCompatibleKernelPackages =
        lib.filterAttrs (
          name: kernelPackages:
            (builtins.match "linux_[0-9]+_[0-9]+" name)
            != null
            && (builtins.tryEval kernelPackages).success
            && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
        )
        pkgs.linuxKernel.packages;
      latestKernelPackage = lib.last (
        lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
          builtins.attrValues zfsCompatibleKernelPackages
        )
      );
    in {
      kernelPackages = latestKernelPackage;

      # INFO: plymouth automatically enabled via flake:nixos-plymouth

      # Enable "Silent boot"
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "rd.udev.log_level=3"
        "rd.systemd.show_status=auto"
      ];

      loader = {
        efi = {
          efiSysMountPoint = "/boot"; # ← use the same mount point here.
          canTouchEfiVariables = true;
        };
        timeout = 3;

        limine = {
          enable = true;
        };
      };
    };

    # boot partition
    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-label/NIXBOOT";
        fsType = "vfat";
        neededForBoot = true;
      };
    };

    systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [];

    # reduce journald logs
    services.journald.extraConfig = ''
      SystemMaxUse=50M
    '';
  };
}
