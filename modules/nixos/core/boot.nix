{
  config,
  pkgs,
  ...
}: let
  inherit
    (pkgs.lib)
    filterAttrs
    last
    sort
    versionOlder
    mkForce
    ;
  # use the latest ZFS-compatible Kernel
  # https://wiki.nixos.org/wiki/ZFS
  zfsCompatibleKernelPackages =
    filterAttrs (
      name: kernelPackages:
        (builtins.match "linux_[0-9]+_[0-9]+" name)
        != null
        && (builtins.tryEval kernelPackages).success
        && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
    )
    pkgs.linuxKernel.packages;
  latestKernelPackage = last (
    sort (a: b: (versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in {
  boot = {
    kernelPackages = latestKernelPackage;

    # INFO: plymouth automatically enabled via flake:nixos-plymouth

    # Enable "Silent boot"
    consoleLogLevel = 3;
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

  systemd.services.NetworkManager-wait-online.wantedBy = mkForce [];
}
