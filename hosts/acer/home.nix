{ pkgs, ... }:
{
  monitors = {
    "eDP-1" = {
      isMain = true;
      scale = 1.0;
      mode = {
        width = 1920;
        height = 1200;
        refresh = 60.0;
      };
      position = {
        x = 0;
        y = 0;
      };
      rotation = 0;
    };
  };

  custom = {

    # theme
    stylix = {
      cursor = {
        package = pkgs.capitaine-cursors-themed;
        name = "Capitaine Cursors (Palenight)";
      };
      icons = {
        package = pkgs.kora-icon-theme;
        dark = "kora-pgrey";
      };
    };

    cyanrip.enable = true;
    foliate.enable = true;
    freetube.enable = true;
    protonapp.enable = true;
    qobuz-player.enable = true;
    spotify.enable = true;
    thunderbird.enable = true;
    wlsunset.enable = true;
  };
}
