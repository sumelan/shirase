{
  self,
  pkgs,
  ...
}: {
  imports = [
    (self + "/users/syncoid/syncoid.nix")
  ];

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      lzop # fast file compressor
      mbuffer # noticeably improves throughput on slow/unstable links
      ;
  };

  # sync zfs to HDDs on desktop
  services.syncoid = {
    enable = true;
    # 23:14 daily
    interval = pkgs.lib.mkDefault "*-*-* 23:14:00";
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
}
