{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    playerctl
    youtube-music
  ];

  xdg.desktopEntries = {
    "com.github.th_ch.youtube_music" = {
      name = "YouTube Music";
      icon = "youtube-music";
      exec = "youtube-music %U --enable-wayland-ime --wayland-text-input-version=3";
      categories = [ "AudioVideo" ];
      type = "Application";
    };
  };

  programs.niri.settings.binds = with config.lib.niri.actions; {
    "Mod+Y" = {
      action = spawn "youtube-music" "%U" "--enable-wayland-ime" "--wayland-text-input-version=3";
      hotkey-overlay.title = "YouTube Music";
    };
  };

  services.playerctld.enable = true;

  custom.persist = {
    home.directories = [
      ".config/YouTube Music"
    ];
  };
}
