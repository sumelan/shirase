{
  config,
  functions,
  ...
}: let
  inherit (functions.recursive) attrsList;
in {
  hjem.users.sumelan.rum = {
    programs.noctalia = {
      enable = true;
      package = config.programs.noctalia.package;
      settings = attrsList [
        (import ./_config.nix {inherit config;})
        (import ./_bar.nix {inherit config;})
        (import ./_widget.nix {inherit config;})
      ];
    };
  };

  custom.fileSystem = {
    cache.home.directories = [
      ".cache/noctalia"
      ".local/state/noctalia"
    ];
  };
}
