{
  config,
  functions,
  ...
}: let
  inherit (functions.recursive) attrsList;
in {
  hjem.users.sumelan.rum = {
    programs.dux-shell = {
      inherit (config.programs.dux-shell) enable package;
      settings = attrsList [
        (import ./_config.nix {inherit config;})
        (import ./_bar.nix {})
        (import ./_greeter.nix {})
        (import ./_lock.nix {inherit config;})
      ];
      plugin_settings = import ./_plugin_config.nix {inherit config;};
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
