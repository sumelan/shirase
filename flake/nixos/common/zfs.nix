{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkMerge
    ;
in
  # NOTE: zfs datasets are created via install.sh
  {
    options.custom = {
      zfs = {
        encryption = mkEnableOption "zfs encryption" // {default = true;};
      };
    };

    config = mkMerge [
      {
        boot = {
          kernelPackages = pkgs.linuxPackages_xanmod_latest;
          # lock xanmod version
          # kernelPackages =
          #   assert assertMsg (versionOlder pkgs.zfs_unstable.version "2.3")
          #     "zfs 2.3 supports kernel 6.11 or greater";
          #   pkgs.linuxPackagesFor (
          #     pkgs.linux_xanmod_latest.override {
          #       argsOverride = rec {
          #         version = "6.10.11";
          #         modDirVersion = versions.pad 3 "${version}-xanmod1";
          #         src = pkgs.fetchFromGitHub {
          #           owner = "xanmod";
          #           repo = "linux";
          #           rev = modDirVersion;
          #           hash = "sha256-FDWFpiN0VvzdXcS3nZHm1HFgASazNX5+pL/8UJ3hkI8=";
          #         };
          #       };
          #     }
          #   );
          zfs = {
            devNodes =
              if config.hardware.cpu.intel.updateMicrocode
              then "/dev/disk/by-id"
              else "/dev/disk/by-partuuid";

            package = pkgs.zfs_unstable;

            requestEncryptionCredentials = config.custom.zfs.encryption;
          };
        };

        services.zfs = {
          autoScrub.enable = true;
          trim.enable = true;
        };

        # 16GB swap
        swapDevices = [{device = "/dev/disk/by-label/SWAP";}];

        # standardized filesystem layout
        fileSystems = {
          # NOTE: root and home are on tmpfs
          # root partition, exists only as a fallback, actual root is a tmpfs
          "/" = {
            device = "zroot/root";
            fsType = "zfs";
            neededForBoot = true;
          };

          # uncomment to use separate home dataset
          # "/home" = {
          #   device = "zroot/home";
          #   fsType = "zfs";
          #   neededForBoot = true;
          # };

          # boot partition
          "/boot" = {
            device = "/dev/disk/by-label/NIXBOOT";
            fsType = "vfat";
          };

          "/nix" = {
            device = "zroot/nix";
            fsType = "zfs";
          };

          # by default, /tmp is not a tmpfs on nixos as some build artifacts can be stored there
          # when using / as a small tmpfs for impermanence, /tmp can then easily run out of space,
          # so create a dataset for /tmp to prevent this
          # /tmp is cleared on boot via `boot.tmp.cleanOnBoot = true;`
          "/tmp" = {
            device = "zroot/tmp";
            fsType = "zfs";
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
      }
    ];
  }
