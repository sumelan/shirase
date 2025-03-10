_: {
  services.blueman-applet = {
    enable = true;
  };

  programs.niri.settings.window-rules = [
    {
      matches = [ { app-id = "^(.blueman-manager-wrapped)$"; } ];
      open-floating = true;
    }
  ];
}
