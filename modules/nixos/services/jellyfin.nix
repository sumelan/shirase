_: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  custom.fileSystem = {
    persist.root.directories = [
      {
        directory = "/var/lib/jellyfin";
        user = "jellyfin";
        group = "jellyfin";
      }
    ];

    cache.root.directories = [
      {
        directory = "/var/cache/jellyfin";
        user = "jellyfin";
        group = "jellyfin";
      }
    ];
  };
}
