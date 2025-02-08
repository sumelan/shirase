{
  lib,
  pkgs,
  ...
}:
{
  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;

    # Bootloader
    # enable stage-1 bootloader
    initrd.systemd.enable = true;
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        theme = pkgs.custom.hyperfluent-grub-theme;
      };
      timeout = 3;
    };
  };

  # faster boot times
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];

  # reduce journald logs
  services.journald.extraConfig = ''SystemMaxUse=50M'';
}
