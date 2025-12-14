_: {
  imports = [
    ./plugins.nix
    ./settings.nix
  ];

  programs = {
    dankMaterialShell = {
      enable = true;
      systemd = {
        enable = false;
        restartIfChanged = false;
      };
    };
  };

  custom.persist = {
    home = {
      directories = [
        ".config/niri/dms"
        ".local/state/DankMaterialShell"
      ];
      cache.directories = [
        ".cache/DankMaterialShell"
      ];
    };
  };
}
