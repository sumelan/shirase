_: {
  programs.dux-calendar = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
      restartIfChanged = true;
    };
  };

  custom.fileSystem = {
    cache.home.directories = [
      ".cache/dank-calendar"
      ".local/share/dankcal"
      ".local/state/dankcal"
    ];
  };
}
