{pkgs, ...}: {
  hjem.users.sumelan = {
    packages = [pkgs.tuba];
  };

  custom.fileSystem = {
    cache.home.directories = [
      ".cache/tuba"
    ];
  };
}
