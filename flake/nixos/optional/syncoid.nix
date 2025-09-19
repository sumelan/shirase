{
  lib,
  config,
  host,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.custom = {
    syncoid.enable = mkEnableOption "syncoid";
  };

  config = mkIf config.custom.syncoid.enable {
    programs.ssh = {
      extraConfig = "
        Host sakura
          Hostname 192.168.68.62
          Port 22
          User syncoid
      ";
    };

    # allow syncoid to ssh into HDDs
    users.users = {
      "syncoid" = {
        # services.syncoid automaticall set user "syncoid" as systemuser
        openssh.authorizedKeys.keyFiles = [
        ];
      };
    };

    # sync zfs to HDDs on desktop
    services.syncoid = {
      enable = true;

      # 23:50 daily
      interval = "*-*-* 23:50:00";

      commands."remote" = {
        source = "zroot/persist";
        target = "root@sakura:media/WD4T/${host}";
        extraArgs = [
          "--no-sync-snap" # restrict itself to existing snapshots
          "--delete-target-snapshots" # snapshots which are missing on the source will be destroyed on the targe
        ];
        localSourceAllow = config.services.syncoid.localSourceAllow ++ ["mount"];
        localTargetAllow = config.services.syncoid.localTargetAllow ++ ["destroy"];
      };
    };

    # persist syncoid .ssh
    # For syncoid to be able to create /var/lib/syncoid/.ssh/ and to use custom ssh_config or known_hosts.
    custom.persist = {
      root.directories = ["/var/lib/syncoid"];
    };
  };
}
