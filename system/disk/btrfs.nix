{ lib, ... }:
# NOTE: partitions and subvolumes are created via install.sh
{ 
  fileSystems."/" = {
    device = "/root";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" "noatime" ];
  };

  boot.initrd.enable = true;
  boot.initrd.supportedFilesystems = [ "btrfs" ];
  boot.initrd.postResumeCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  fileSystems = {
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

    # cache are files that should be persisted, but not to snapshot
    # e.g. npm, cargo cache etc, that could always be redownloaded
    "/cache" = {
      device = "/cache";
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
