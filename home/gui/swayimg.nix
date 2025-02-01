{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.swayimg ];

  xdg.mimeApps.defaultApplications = {
    "image/jpeg" = "swayimg.desktop";
    "image/gif" = "swayimg.desktop";
    "image/webp" = "swayimg.desktop";
    "image/png" = "swayimg.desktop";
  };
}
