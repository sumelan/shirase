{ lib, config, ... }:
{
  programs = {
    cavalier = {
      enable = true;
      settings.general = {
        ShowControls = lib.mkForce false;
        Mode = 3; # DrawingMode.BarsBox.
        ColorProfiles =
          with config.lib.stylix.colors.withHashtag;
          # Create a list consisting of a single element.
          lib.singleton {
            Name = "Stylix";
            FgColors = [
              base06
              base08
              base0A
              base0C
              base0E
            ];
            BgColors = [ base01 ];
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
    };
  };
  stylix.targets.cavalier.enable = false;
}
