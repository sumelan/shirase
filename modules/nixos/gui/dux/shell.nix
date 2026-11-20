_: {
  programs.dux-shell = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
      restartIfChanged = true;
    };
    plugins = {
      quickCapture.enable = true;
      dankKDEConnect.enable = true;
      modernClock.enable = true;
      fcitx5Indicator.enable = true;
    };
  };
}
