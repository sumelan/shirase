{ lib, ... }:
# NOTE: partitions and subvolumes are created via install.sh
{ 
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" "noatime" ];
  };

  # https://discourse.nixos.org/t/impermanence-vs-systemd-initrd-w-tpm-unlocking/25167/3
  # https://guekka.github.io/nixos-server-1/
  boot.initrd.enable = true;
  boot.initrd.supportedFilesystems = [ "btrfs" ];
  boot.initrd.systemd.services.rollback =
    let
      device = "/dev/disk/by-label/NIXROOT";
      # unitName should be like
      # "dev-disk-by\\x2dlabel-NIXROOT.device"
      unitName =
        lib.removePrefix "-" (
          lib.replaceStrings
            [
              "-"
              "/"
            ]
            [
              "\\x2d"
              "-"
            ]
            device
        )
        + ".device";         
    in
    {
      description = "Rollback BTRFS root subvolume";
      wantedBy = [ "initrd.target" ];
      requires = [ unitName ];
      after = [ unitName ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
          mkdir -p /mnt

          # mount the btrfs root to /mnt to manipulate btrfs subvolume
          mount -o subvol=/ -t btrfs ${device} /mnt

          # remove some subvlumes in /root
          btrfs subvolume list -o /mnt/root |
          cut -f9 -d' ' |
          while read subvolume; do
              echo "deleting /$subvolume subvolume..."
              btrfs subvolume delete "/mnt/$subvolume"
          done &&
          echo "deleting /root subvolume..." &&
          btrfs subvolume delete /mnt/root

          echo "restoring blank /root subvolume..."
          btrfs subvolume snapshot /mnt/root-blank /mnt/root

          # unmount /mnt and continue on the boot process
          umount /mnt
      '';
    };

  fileSystems = {
    "/nix" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    # by default, /tmp is not a tmpfs on nixos as some build artifacts can be stored there
    # when using / as a small tmpfs for impermanence, /tmp can then easily run out of space,
    # so create a dataset for /tmp to prevent this
    # /tmp is cleared on boot via `boot.tmp.cleanOnBoot = true;`
    "/tmp" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "btrfs";
      options = [ "subvol=tmp" "compress=zstd" "noatime" ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" ];
      neededForBoot = true;
    };

    # cache are files that should be persisted, but not to snapshot
    # e.g. npm, cargo cache etc, that could always be redownloaded
    "/cache" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "btrfs";
      options = [ "subvol=cache" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
  };
  # auto-scrubbing
  services.btrfs.autoScrub.enable = true;
}
