{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.btrfs;
in
{
  options.custom = {
    btrfs = with lib; {
      enable = mkEnableOption "btrfs filesystem";
      wipeRootOnBoot = mkEnableOption "wipe the rot volume on boot" // {
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [ 
    {
      services.btrfs.autoScrub.enable = true;
    }

    { 
      # nixos-generate-config --show-hardware-config doesn't detect mount options automatically,
      # so to enable compression, you must specify it and other mount options in a persistent configuration:
      fileSystems = {
        "/".options = [ "compress=zstd" "noatime" ];

        "/nix".options = [ "compress=zstd" "noatime" ];
        
        "/home" = {
          options = [ "compress=zstd" "noatime" ];
          neededForBoot = true;
        };

        "/persist" = {
          options = [ "compress=zstd" "noatime" ];
          neededForBoot = true;
        };

        "/var/lib" = {
          options = [ "compress=zstd" "noatime" ];
          neededForBoot = true;
        };

        "/var/log" = {
          options = [ "compress=zstd" "noatime" ];
          neededForBoot = true;
        };
      };
    }

    (lib.mkIf cfg.wipeRootOnBoot {
      # https://discourse.nixos.org/t/impermanence-vs-systemd-initrd-w-tpm-unlocking/25167/3
      # https://guekka.github.io/nixos-server-1/
      boot.initrd.systemd.enable = true;
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
