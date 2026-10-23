{pkgs, ...}: {
  hjem.users.sumelan = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        protonmail-desktop
        proton-pass
        proton-vpn
        ;
    };
  };

  custom.fileSystem = {
    persist.home.directories = [
      ".config/Proton"
      ".config/Proton Mail"
      ".config/Proton Pass"
    ];

    cache.home.directories = [
      ".cache/Proton"
    ];
  };
}
