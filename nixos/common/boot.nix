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
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 3;
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
