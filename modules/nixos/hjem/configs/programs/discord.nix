{pkgs, ...}: {
  hjem.users.sumelan = {
    packages = [
      pkgs.vesktop
    ];
  };

  custom.fileSystem = {
    persist.home.directories = [
      ".config/vesktop"
    ];
  };
}
