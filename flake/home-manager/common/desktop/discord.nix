{config, ...}: {
  programs.vesktop = {
    enable = true;
  };

  programs.niri.settings = {
    binds = {
      "Mod+W" = {
        action.spawn = ["sh" "-c" "uwsm app -- vesktop"];
        hotkey-overlay.title = ''<span foreground="${config.lib.stylix.colors.withHashtag.base0B}">[Application]</span> Vesktop'';
      };
    };
  };

  custom.persist = {
    home.directories = [
      ".config/vesktop"
    ];
  };
}
