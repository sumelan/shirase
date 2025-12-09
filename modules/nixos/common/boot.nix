{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkForce mkMerge;
in
  mkMerge [
    {
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

      # faster boot times
      systemd.services.NetworkManager-wait-online.wantedBy = mkForce [];
    }
    {
      # kernel
      boot.kernelPackages = pkgs.linuxPackages_zen;
    }
    {
      # reduce journald logs
      services.journald.extraConfig = ''SystemMaxUse=50M'';
    }
  ]
