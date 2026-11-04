{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) concatStringsSep;
in {
  hjem.users.sumelan.rum = {
    programs.dux-shell = {
      inherit (config.programs.dux-shell) enable package;
    };
  };

  environment.sessionVariables = {
    DMS_HIDE_TRAYIDS = concatStringsSep "," [
      "Fcitx"
    ];
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
