{pkgs, ...}: {
  hjem.users.sumelan = {
    packages = [
      pkgs.vesktop
      pkgs.dissent
    ];
  };

  custom.fileSystem = {
    persist.home.directories = [
      ".config/vesktop"
      ".config/dissent"
    ];
    cache.home.directories = [
      ".cache/dissent"
    ];
  };
}
