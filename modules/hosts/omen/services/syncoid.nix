_: {
  flake.modules.nixos."hosts/omen" = {config, ...}: {
    services.syncoid = {
      commands."remote" = {
        source = "zroot/persist";
        target = "syncoid@192.168.68.62:IW2T/omen";
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
