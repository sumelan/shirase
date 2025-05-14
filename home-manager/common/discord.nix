{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (discord.override {
      withOpenASAR = true;
    })
  ];

  xdg.desktopEntries = {
    discord = {
      name = "Discord";
      genericName = "All-in-one cross-platform voice and text chat for gamers";
      icon = "discord";
      exec = "discord %U --enable-wayland-ime --wayland-text-input-version=3";
      mimeType = [ "x-scheme-handler/discord" ];
      terminal = false;
      categories = [
        "Network"
        "InstantMessaging"
      ];
      comment = "Open-source alternative of Discord desktop's 'app.asar'";
      type = "Application";
    };
  };

  programs.niri.settings.window-rules = [
    {
      matches = [ { app-id = "^(discord)$"; } ];
      default-column-width.proportion = 0.6;
    }
  ];

  custom.persist = {
    home.directories = [
      ".config/discord"
    ];
  };
}
