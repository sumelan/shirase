{ ... }:
{
  custom = {
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
    waybar = {
      enable = true;
      hidden = false;
      # waybar.persistentWorkspaces = true;
    };
  };

  # build package for testing, but it isn't used
  # home.packages = [ pkgs.hyprlock ];
}
