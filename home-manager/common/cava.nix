_: {
  programs.cava.enable = true;

  stylix.targets.cava = {
    enable = true;
    rainbow.enable = true;
  };

  programs.niri.settings.window-rules = [
    {
      # Mod+C launch cava with app-id
      matches = [ { app-id = "^(cava)$"; } ];
      default-column-width.proportion = 0.4;
      default-window-height.proportion = 0.4;
      open-floating = true;
    }
  ];
}
