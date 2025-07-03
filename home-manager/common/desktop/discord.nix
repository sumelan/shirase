{
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [ webcord ];

  programs.niri.settings = {
    binds = {
      "Mod+W" = lib.custom.niri.openApp {
        app = pkgs.webcord;
      };
    };
    window-rules = lib.singleton {
      matches = lib.singleton {
        app-id = "^(WebCord)$";
      };
      default-column-width.proportion = 0.7;
    };
  };

  custom.persist = {
    home.directories = [
      ".config/WebCord"
    ];
  };
}
