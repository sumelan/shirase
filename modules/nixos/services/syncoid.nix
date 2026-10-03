_: {
  flake.modules.nixos.syncoid = {
    # allow syncoid to ssh into HDDs
    users.users = {
      "syncoid" = {
        # services.syncoid automaticall set user "syncoid" as systemuser
        openssh.authorizedKeys.keys = [
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
    custom.fileSystem = {
      persist.root.directories = [
        {
          directory = "/var/lib/syncoid/.ssh";
          user = "syncoid";
          group = "syncoid";
          mode = "0700";
        }
      ];
    };

    systemd.tmpfiles.settings.preservation = {
      "/var/lib/syncoid".d = {
        user = "syncoid";
        group = "syncoid";
        mode = "0700";
      };
    };
  };
}
