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
      icon = {
        package = pkgs.papirus-nord.override {
          accent = "auroraorange";
        };
        darkName = "Papirus-Dark";
        lightName = "Papirus-Light";
      };
    };

    brave.enable = false;
    cyanrip.enable = true;
    ebook.enable = true;
    thunderbird.enable = true;
  };
}
