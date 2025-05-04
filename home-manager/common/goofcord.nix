{ pkgs, ... }:
{
  home.packages = with pkgs; [ goofcord ];

  xdg.desktopEntries = {
    goofcord = {
      name = "GoofCord";
      genericName = "Internet Messenger";
      icon = "goofcord";
      exec = "goofcord %U --enable-wayland-ime --wayland-text-input-version=3";
      terminal = false;
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      comment = "Highly configurable and privacy-focused Discord client";
      type = "Application";
    };
  };

  programs.niri.settings.window-rules = [
    {
      matches = [ { app-id = "^(goofcord)$"; } ];
      default-column-width.proportion = 0.5;
    }
  ];

  custom.persist = {
    home.directories = [
      ".config/goofcord"
    ];
  };
}
