_: {
  programs = {
    vesktop = {
      enable = true;
    };

    niri.settings = {
      binds = {
        "Mod+D" = {
          action.spawn = ["vesktop"];
          hotkey-overlay.title = ''<span foreground="#B1C89D">[  Vesktop]</span> Discord Client'';
        };
      };
    };
  };

  custom.persist = {
    home.directories = [
      ".config/vesktop"
    ];
  };
}
