{
  lib,
  config,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkIf
    genAttrs
    ;
in {
  imports = with inputs.nixos-hardware.nixosModules; [
    common-pc
    common-pc-ssd
    common-cpu-amd
    common-gpu-amd
  ];

  # btrbk server setting
  # add ssh key to perform btrfs command
  services.btrbk.sshAccess = mkIf config.custom.btrbk.enable [
    {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFGww+bXaeTXj6s10G4V8Kz2PqGfI6tU4rd8KfxxoQj9 btrbk";
      roles = [
        "target"
        "info"
        "receive"
        "delete"
      ];
    }
  ];

  custom = let
    enableList = [
      "alsa"
      "hdds"
      "logitech"
    ];
    disableList = [
      "audiobookshelf"
      "distrobox"
      "steam"
    ];
  in
    {
      stylix.colorTheme = "nord";
    }
    // genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
