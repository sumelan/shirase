{lib, ...}: {
  flake.modules.nixos."hosts/sakura" = {
    config,
    pkgs,
    ...
  }: {
    # noticeably improves throughput on slow/unstable links
    environment.systemPackages = [pkgs.mbuffer];

    services.syncoid = {
      commands."local-hdd" = lib.mkIf config.custom.hardware.hdds.ironWolf {
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
