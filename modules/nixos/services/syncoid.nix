_: {
  flake.modules.nixos.syncoid = {pkgs, ...}: {
    # allow syncoid to ssh into HDDs
    users.users = {
      syncoid = {
        isNormalUser = false; # keep it a service account...
        group = "syncoid";
        shell = pkgs.bashInteractive; # ...but with a real shell
        # services.syncoid automaticall set user "syncoid" as systemuser
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGU8XyODM1wUPrd98dItryAHIXSHKUAM2RT42UtIKhBF syncoid@omen"
        ];
      };
    };

    # sync zfs to HDDs on desktop
    services.syncoid = {
      enable = true;
      # 23:14 daily
      interval = "*-*-* 23:14:00";
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
