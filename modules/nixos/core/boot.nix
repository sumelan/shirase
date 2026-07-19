{lib, ...}: {
  flake.modules.nixos.core = {pkgs, ...}: {
    boot = {
      kernelPackages = pkgs.linuxPackages_xanmod;

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
