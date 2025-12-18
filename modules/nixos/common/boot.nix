{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce mkMerge;
in
  mkMerge [
    # bootloader
    {
      boot.loader = {
        efi = {
          efiSysMountPoint = "/boot"; # ← use the same mount point here.
          canTouchEfiVariables = true;
        };
        limine = {
          enable = true;
        };
        timeout = 3;
      };
    }
    # kernel
    {
      boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
    }
    # misc.
    {
      # faster boot times
      systemd.services.NetworkManager-wait-online.wantedBy = mkForce [];
      # reduce journald logs
      services.journald.extraConfig = ''SystemMaxUse=50M'';
    }
  ]
