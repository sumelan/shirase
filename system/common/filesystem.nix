{ pkgs, self, ... }:
# NOTE: partitions and subvolumes are created via install.sh
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd"
        "noatime"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd"
        "noatime"
      ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [
        "subvol=persist"
        "compress=zstd"
        "noatime"
      ];
      neededForBoot = true;
    };

    # cache are files that should be persisted, but not to snapshot
    # e.g. npm, cargo cache etc, that could always be redownloaded
    "/cache" = {
      device = "/dev/disk/by-label/NIXOS";
      fsType = "btrfs";
      options = [
        "subvol=cache"
        "compress=zstd"
        "noatime"
      ];
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  # auto-scrubbing
  services.btrfs.autoScrub.enable = true;

  # scripts
  environment.systemPackages = [ self.packages.${pkgs.system}.btrfs-scripts ];
}
