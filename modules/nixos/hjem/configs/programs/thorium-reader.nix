{pkgs, ...}: {
  hjem.users.sumelan = {
    packages = [pkgs.thorium-reader];
  };

  custom = {
    fileSystem = {
      persist.home.directories = [
        ".config/EDRLab.ThoriumReader"
      ];
    };
  };
}
