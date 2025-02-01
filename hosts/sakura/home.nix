{ ... }:
{
  custom = {
    monitors = [
      {
        name = "HDMI-A-1";
        width = 2560;
        height = 1440;
        refreshRate = 60;
        vrr = false;
        position = "0x0";
        workspaces = [
          1
          2
          3
          4
          5
          6
          7
          8
        ];
      }
      {
        name = "DP-1";
        width = 2560;
        height = 1440;
        position = "0x1440";
        vertical = false;
        workspaces = [
          9
          10
        ];
        defaultWorkspace = 9;
      }
    ];
    amberol.enable = true;
    easyEffects = {
      enable = true;
      preset = "Bass Enhancing + Perfect EQ";
    };
    foliate.enable = true;
    ghostty.enable = false;
    hyprland = {
      lock = false;
      qtile = false;
    };
    inkscape.enable = true;
    krita.enable = true;
    rustdesk.enable = true;
    thunderbird.enable = true;
    vlc.enable = true;
    waybar = {
      enable = true;
      hidden = false;
      # waybar.persistentWorkspaces = true;
    };
  };

  # build package for testing, but it isn't used
  # home.packages = [ pkgs.hyprlock ];
}
