{ pkgs, ... }:
{
  home.packages = with pkgs; [ mpv ];

  custom.persist = {
    home.directories = [
      ".local/state/mpv" # watch later
    ];
  };
}
