{
  lib,
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [ webcord ];

  programs.niri.settings = {
    binds."Mod+W" = config.niri-lib.open {
      app = pkgs.webcord;
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
