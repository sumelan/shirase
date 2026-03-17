{lib, ...}: let
  inherit (lib) getExe;
in {
  flake.modules.homeManager.rmpc = {
    config,
    pkgs,
    ...
  }: {
    home.packages = [pkgs.rmpc];

    xdg.configFile = {
      "rmpc/config.ron".source = import ./_config.nix {inherit config pkgs;};
      "rmpc/themes/nord.ron".source = import ./_nord.nix {inherit pkgs;};
    };

    xdg.desktopEntries = {
      rmpc = {
        name = "Rmpc";
        genericName = "MPD Client";
        icon = "mpd";
        terminal = true;
        exec = getExe pkgs.rmpc;
      };
    };

    custom.cache.home.directories = [
      ".cache/rmpc/youtube"
    ];
  };
}
