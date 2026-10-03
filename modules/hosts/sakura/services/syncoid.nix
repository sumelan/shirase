{lib, ...}: {
  flake.modules.nixos."hosts/sakura" = {config, ...}: {
    services.syncoid = {
      commands."local" = lib.mkIf config.custom.hardware.hdds.ironWolf {
        source = "zroot/persist";
        target = "IW2T/sakura";
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
