{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    syncoid.enable = mkEnableOption "syncoid";
  };

  config = mkIf config.custom.syncoid.enable {
    # allow syncoid to ssh into HDDs
    users.users = {
      "syncoid" = {
        # services.syncoid automaticall set user "syncoid" as systemuser
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0nylmhn7vyEeF1Lec3oAy2DbHOZrPYWZ5JkDefMslq syncoid"
        ];
      };
    };

    # sync zfs to HDDs on desktop
    services.syncoid = {
      enable = true;
      # 23:50 daily
      interval = "*-*-* 23:50:00";
    };

    # persist syncoid .ssh
    # syncoid create `/var/lib/syncoid/.ssh/` and use custom ssh_config or known_hosts.
    custom.persist = {
      root.directories = ["/var/lib/syncoid"];
    };
  };
}
