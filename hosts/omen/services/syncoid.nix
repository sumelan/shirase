{config, ...}: {
  services.syncoid = {
    # 21:15 daily
    interval = "*-*-* 21:15:00";

    commands."remote" = {
      source = "zroot/persist";
      target = "sakura-syncoid:IW2T/omen";
      extraArgs = [
        "--no-sync-snap" # restrict itself to existing snapshots
        "--delete-target-snapshots" # snapshots which are missing on the source will be destroyed on the target
      ];
      localSourceAllow = config.services.syncoid.localSourceAllow ++ ["mount"];
      localTargetAllow = config.services.syncoid.localTargetAllow ++ ["destroy"];
    };
  };
}
