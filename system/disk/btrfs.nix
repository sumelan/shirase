{
  lib,
  config,
  ...
}:
# NOTE: partitions and subvolumes are created via install.sh
let
  cfg = config.custom.btrfs;
in
{
  options.custom = {
    btrfs = with lib; {
      wipeRootOnBoot = mkEnableOption "wipe the root volume on each boot"// {
        default = true;
      };
    };
  };

  config = (lib.mkMerge [ 
    { 
      fileSystems = {
        # root volume, wiped on boot if enable
        "/" = {
          device = "/root";
          fsType = "btrfs";
          options = [ "subvol=root" "compress=zstd" "noatime" ];
        };

        "/boot" = {
          device = "/dev/disk/by-label/NIXBOOT";
          fsType = "vfat";
          options = [ "fmask=0022" "dmask=0022" ];
        };

        "/nix" = {
          device = "/nix";
          fsType = "btrfs";
          options = [ "subvol=nix" "compress=zstd" "noatime" ];
        };

        "/home" = {
          device = "/home";
          fsType = "btrfs";
          options = [ "subvol=home" "compress=zstd" ];
        };

        "/persist" = {
          device = "/persist";
          fsType = "btrfs";
          options = [ "subvol=persist" "compress=zstd" "noatime" ];
          neededForBoot = true;
        };

        # /var/cache are files that should be persisted, but not to snapshot
        # e.g. npm, cargo cache etc, that could always be redownloaded
        "/var/cache" = {
          device = "/cache";
          fsType = "btrfs";
          options = [ "subvol=cache" "compress=zstd" "noatime" ];
          neededForBoot = true;
        };
      };
    }

    {
      # auto-scrubbing
      services.btrfs.autoScrub.enable = true;
    }

    (lib.mkIf cfg.wipeRootOnBoot {
      # https://discourse.nixos.org/t/impermanence-vs-systemd-initrd-w-tpm-unlocking/25167/3
      # https://guekka.github.io/nixos-server-1/
      boot.initrd.enable = true;
      boot.initrd.supportedFilesystems = [ "btrfs" ];
      boot.initrd.systemd.services.rollback = 
          let
            device = "/dev/disk/by-partlabel/disk-disk0-root";
            # unitName should be like
            # "dev-disk-by\\x2dpartlabel-disk\\x2ddisk0\\x2droot.device"
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
    })
  ]);
}
