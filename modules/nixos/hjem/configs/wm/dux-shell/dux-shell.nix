{config, ...}: {
  hjem.users.sumelan.rum = {
    programs.dux-shell = {
      inherit (config.programs.dux-shell) enable package;
    };
  };

  custom.fileSystem = {
    cache.home.directories = [
      ".config/dms/themes"
      ".cache/dms"
      ".local/state/dms"
    ];
  };
}
