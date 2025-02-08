{ ... }:
{
  custom = {
    niri.monitors = [
      name = "HDMI-A-1"
        width = 2560;
        height = 1440;
        x-position = 0;
        y-position = 0;
      };
      name =
        width = 2560;
        height = 1440;
        x-position = 0;
        y-position = 1440;
      };
    };

    amberol.enable = true;
    easyEffects = {
      enable = true;
      preset = "Bass Enhancing + Perfect EQ";
    };
    foliate.enable = true;
    ghostty.enable = false;
    inkscape.enable = true;
    krita.enable = true;
    rustdesk.enable = true;
    thunderbird.enable = true;
    vlc.enable = true;
  };

  # build package for testing, but it isn't used
  # home.packages = [ pkgs.hyprlock ];
}
