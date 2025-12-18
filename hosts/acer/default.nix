{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf genAttrs;
in {
  # FIXME: add networking.hostID.
  networking.hostId = "37668564";

  services = {
    syncoid = {
      commands."remote" = mkIf config.custom.syncoid.enable {
        source = "zroot/persist";
        target = "root@sakura:zfs-elements4T-1/media/acer";
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
    ];
    disableList = [
      "distrobox"
      "syncoid"
    ];
  in
    genAttrs enableList (_name: {enable = true;})
    // genAttrs disableList (_name: {enable = false;});
}
