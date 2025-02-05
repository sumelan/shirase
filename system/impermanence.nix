{
  lib,
  config,
  ...
}:
{
  options.custom = with lib; {
    impermanence.enable = mkEnableOption "impermanence";
  };

  config = lib.mkIf config.custom.impermanence.enable {
    # filesystem modifications needed for impermanence
    fileSystems."/persist".neededForBoot = true;
    fileSystems."/var/log".neededForBoot = true;
    fileSystems."/var/tmp".neededForBoot = true;

    boot.initrd.systemd = {
      enable = true;
      services.rollback = 
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
            # Mount the btrfs root to /mnt
            mount -o subvol=root -t btrfs ${device} /mnt
            btrfs subvolume list -o /mnt/root
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
            umount /mnt
          '';
        };
    };
  };
}
