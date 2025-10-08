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
  networking.hostId = "226c6834";

  programs.ssh = {
    extraConfig = ''
      Host sakura
        HostName 192.168.68.62
        Port 22
        User root
    '';
  };

  services = {
    # disable accidentary push powerkey
    logind.settings.Login.HandlePowerKey = "ignore";

    syncoid = {
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
    genAttrs enableList (_name: {
      enable = true;
    })
    // genAttrs disableList (_name: {
      enable = false;
    });
}
