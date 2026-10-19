{
  config,
  lib,
  ...
}: {
  flake.modules.nixos.syncoid = {pkgs, ...}: {
    imports = [config.flake.modules.nixos."users/syncoid"];

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
      interval = lib.mkDefault "*-*-* 23:14:00";
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
