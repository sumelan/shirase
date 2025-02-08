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
        theme = pkgs.stdenv.mkDerivation {
          pname = "HyperFluent-GRUB-Theme";
          version = "1.0.1";
          src = pkgs.fetchFromGitHub {
            owner = "Coopydood";
            repo = "HyperFluent-GRUB-Theme";
            rev = "v1.0.1";
            hash = "sha256-Als4Tp6VwzwHjUyC62mYyiej1pZL9Tzj4uhTRoL+U9Q=";
          };
          installPhase = "cp -r $src/nixos $out";
        };
      };
      timeout = 3;
    };
  };

  # faster boot times
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];

  # reduce journald logs
  services.journald.extraConfig = ''SystemMaxUse=50M'';
}
