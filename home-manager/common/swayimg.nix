{ pkgs, ... }:
{
  home.packages = with pkgs; [ swayimg ];

  xdg.mimeApps.defaultApplications = {
    "image/jpeg" = "swayimg.desktop";
    "image/gif" = "swayimg.desktop";
    "image/webp" = "swayimg.desktop";
    "image/png" = "swayimg.desktop";
  };

  programs.niri.settings.window-rules = [
    {
      matches = [ { app-id = "^(swayimg)$"; } ];
      open-floating = true;
    }
  ];
}
