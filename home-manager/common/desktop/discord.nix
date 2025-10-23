{pkgs, ...}: {
  home.packages = [pkgs.webcord-vencord];

  programs.niri.settings = {
    binds = {
      "Mod+W" = {
        action.spawn = ["webcord"];
        hotkey-overlay.title = ''<span foreground="#5E81AC">[Application]</span> WebCord'';
      };
    };
  };

  custom.persist = {
    home.directories = [
      ".config/WebCord"
    ];
  };
}
