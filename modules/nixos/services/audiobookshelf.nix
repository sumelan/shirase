_: {
  flake.modules.nixos.audiobookshelf = _: {
    services.audiobookshelf = {
      enable = true;
      host = "0.0.0.0"; # "127.0.0.1" means localhost only
      port = 8234;
      openFirewall = true;
    };

    custom.fileSystem = {
      persist.root.directories = [
        {
          directory = "/var/lib/audiobookshelf/library";
          user = "audiobookshelf";
          group = "audiobookshelf";
        }
        # metadata backups
        {
          directory = "/var/lib/audiobookshelf/backups";
          user = "audiobookshelf";
          group = "audiobookshelf";
        }
      ];
      cache.root.directories = [
        {
          directory = "/var/lib/audiobookshelf/config";
          user = "audiobookshelf";
          group = "audiobookshelf";
        }
        {
          directory = "/var/lib/audiobookshelf/metadata";
          user = "audiobookshelf";
          group = "audiobookshelf";
        }
      ];
    };

    systemd.tmpfiles.settings.preservation = {
      "/var/lib/audiobookshelf".d = {
        user = "audiobookshelf";
        group = "audiobookshelf";
        mode = "0755";
      };
    };
  };
}
