{
  lib,
  config,
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
    # allow syncoid to ssh into HDDs
    users.users = {
      "syncoid" = {
        # services.syncoid automaticall set user "syncoid" as systemuser
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6tX+1PCu+A57NZV0qhGyWMBFdUvPb56kX/cksEyumk sumelan"
        ];
      };
    };

    # sync zfs to HDDs on desktop
    services.syncoid = {
      enable = true;

      # 23:50 daily
      interval = "*-*-* 23:30:00";
    };

    # persist syncoid .ssh
    # For syncoid to be able to create /var/lib/syncoid/.ssh/ and to use custom ssh_config or known_hosts.
    custom.persist = {
      root.directories = ["/var/lib/syncoid"];
    };
  };
}
