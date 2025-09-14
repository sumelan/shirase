{
  lib,
  config,
  host,
  isLaptop,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.custom = {
    syncoid.enable = mkEnableOption "syncoid" // {default = isLaptop;};
  };

  config = mkIf config.custom.syncoid.enable {
    # allow syncoid to ssh into HDDs
    users.users = {
      syncoid.openssh.authorizedKeys.keyFiles = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0zoNZpdcUfZ/Nf8Nj248D3wGlQCLld3LjPGrA6zzXs sumelan"
      ];
    };

    # sync zfs to HDDs on desktop
    services.syncoid = {
      enable = true;

      # 23:50 daily
      interval = "*-*-* 23:50:00";

      commands."remote" = {
        source = "zroot/persist";
        target = "root@sakura:media/4TWD/${host}";
        extraArgs = [
          "--no-sync-snap"
          "--delete-target-snapshots"
        ];
        localSourceAllow = config.services.syncoid.localSourceAllow ++ ["mount"];
        localTargetAllow = config.services.syncoid.localTargetAllow ++ ["destroy"];
      };
    };

    # persist syncoid .ssh
    custom.persist = {
      root.directories = ["/var/lib/syncoid"];
    };
  };
}
