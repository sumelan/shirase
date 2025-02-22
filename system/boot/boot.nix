{
  lib,
  pkgs,
  ...
}:
{
  # bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  # kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # faster boot times
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];

  # reduce journald logs
  services.journald.extraConfig = ''SystemMaxUse=50M'';
}
