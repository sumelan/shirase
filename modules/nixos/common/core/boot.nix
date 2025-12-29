{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce;
in {
  # kernelPackage
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  # boot
  # bootloader
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot"; # ← use the same mount point here.
      canTouchEfiVariables = true;
    };
    limine = {
      enable = true;
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
  # misc.
  boot.loader.timeout = 3;
  # faster boot times
  systemd.services.NetworkManager-wait-online.wantedBy = mkForce [];
  # reduce journald logs
  services.journald.extraConfig = ''
    SystemMaxUse=50M
  '';
}
