{pkgs, ...}: {
  home.packages = [pkgs.webcord-vencord];

  programs.niri.settings = {
    binds = {
      "Mod+W" = {
        action.spawn = ["webcord"];
        hotkey-overlay.title = ''<span foreground="#B1C89D">[  WebCord]</span> Discord Client'';
      };
    };
  };

  custom.persist = {
    home.directories = [
      ".config/WebCord"
    ];
  };
}
