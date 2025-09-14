{
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkForce
    ;
in {
  # bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # plymouth
  boot.plymouth.enable = true;

  # faster boot times
  systemd.services.NetworkManager-wait-online.wantedBy = mkForce [];

  # reduce journald logs
  services.journald.extraConfig = ''SystemMaxUse=50M'';
}
