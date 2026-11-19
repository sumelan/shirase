{pkgs, ...}: {
  hjem.users.sumelan = {
    packages = [pkgs.jellyfin-desktop];
  };

  custom.fileSystem = {
    persist.home.directories = [
      ".local/share/jellyfin-desktop"
    ];

    cache.home.directories = [
      ".cache/jellyfin-desktop"
    ];
  };
}
