{ lib, config, ... }:
{
  programs = {
    cavalier = {
      enable = true;
      settings.general = {
        ShowControls = false;
        Mode = 7;
        ColorProfiles =
          with config.lib.stylix.colors.withHashtag;
          # Create a list consisting of a single element.
          lib.singleton {
            Name = "Stylix";
            FgColors = [
              base0B
              base0C
              base0D
            ];
            BgColors = [ base00 ];
            Theme = 1;
          };
        ActiveProfile = 0;
      };
    };

    niri.settings.window-rules = lib.singleton {
      matches = lib.singleton {
        app-id = "^(org.nickvision.cavalier)$";
      };
      open-floating = true;
      default-column-width.proportion = 0.4;
      default-window-height.proportion = 0.4;
    };
  };
  stylix.targets.cavalier.enable = false;
}
