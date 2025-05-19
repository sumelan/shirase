{ pkgs, ... }:
{
  home.packages = with pkgs; [ youtube-music ];

  xdg.desktopEntries = {
    "com.github.th_ch.youtube_music" = {
      name = "YouTube Music";
      icon = "youtube-music";
      exec = "youtube-music %U --enable-wayland-ime --wayland-text-input-version=3";
      categories = [ "AudioVideo" ];
      type = "Application";
    };
  };

  custom.persist = {
    home.directories = [
      ".config/YouTube Music"
    ];
  };
}
