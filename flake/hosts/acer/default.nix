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
    common-pc-laptop
    common-pc-laptop-ssd
    common-cpu-intel
  ];

  networking.hostId = "226c6834";

  programs.ssh = {
    extraConfig = ''
      Host sakura
        HostName 192.168.68.62
        Port 22
        User root
    '';
  };

  services.syncoid = {
    commands."remote" = mkIf config.custom.syncoid.enable {
      source = "zroot/persist";
      target = "root@sakura:zfs-elements4T-1/media";
      extraArgs = [
        "--no-sync-snap" # restrict itself to existing snapshots
        "--delete-target-snapshots" # snapshots which are missing on the source will be destroyed on the targe
      ];
      localSourceAllow = config.services.syncoid.localSourceAllow ++ ["mount"];
      localTargetAllow = config.services.syncoid.localTargetAllow ++ ["destroy"];
    };
  };

  custom = let
    enableList = [
      "alsa"
      "syncoid"
    ];
    disableList = [
      "distrobox"
    ];
  in
    {
      stylix.colorTheme = "everforest-dark-soft";
    }
    // genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
