{
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkForce
    mkMerge
    ;
in
  mkMerge [
    {
      # bootloader
      boot.loader = {
        efi = {
          efiSysMountPoint = "/boot"; # ← use the same mount point here.
          canTouchEfiVariables = true;
        };
        grub = {
          enable = true;
          efiSupport = true;
          # in case canTouchEfiVariables doesn't work for your system
          #  efiInstallAsRemovable = true;
          devices = ["nodev"];
        };
      };
      # faster boot times
      systemd.services.NetworkManager-wait-online.wantedBy = mkForce [];
      # plymouth
      boot.plymouth.enable = true;
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
