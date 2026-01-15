{lib, ...}: let
  inherit (lib) getExe;
in {
  flake.modules.homeManager.youtube-tui = {pkgs, ...}: {
    home.packages = [pkgs.youtube-tui];

    xdg.desktopEntries = {
      youtube-tui = {
        name = "YouTube-tui";
        genericName = "YouTube Player";
        icon = "youtube";
        terminal = true;
        exec = getExe pkgs.youtube-tui;
      };
    };

    custom.persist.home.directories = [
      ".local/share/youtube-tui"
    ];
  };
}
