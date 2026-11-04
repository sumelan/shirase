{config, ...}: {
  hjem.users.sumelan.rum = {
    programs.dux-shell = {
      inherit (config.programs.dux-shell) enable package;
    };
  };

  custom.fileSystem = {
    persist.home = {
      files = [
        ".config/dms/icc.json"
      ];

      directories = [
        ".config/dms/themes"
      ];
    };

    cache.home.directories = [
      ".cache/dms"
      ".local/state/dms"
    ];
  };
}
