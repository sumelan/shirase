_: {
  flake.modules.nixos.syncoid-sakura = {config, ...}: {
    services.syncoid = {
      commands."zusb" = {
        source = "zroot/persist";
        target = "zusb-iw2T/backups/sakura";
        extraArgs = [
          "--no-sync-snap" # restrict itself to existing snapshots
          "--delete-target-snapshots" # snapshots which are missing on the source will be destroyed on the targe
        ];
        localSourceAllow = config.services.syncoid.localSourceAllow ++ ["mount"];
        localTargetAllow = config.services.syncoid.localTargetAllow ++ ["destroy"];
      };
    };
  };
}
