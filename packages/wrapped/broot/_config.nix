_: {
  imports = [
    {
      luma = ["dark" "unknown"];
      file = "skins/catppuccin-macchiato.hjson";
    }
  ];

  default_flags = "-gs";
  icon_theme = "nerdfont";

  modal = true;
  initial_mode = "command";

  special_paths = {
    "/media" = {
      list = "never";
      sum = "never";
    };
    "~/.config" = {show = "always";};
  };
}
