{ pkgs, ... }:
{
  imports = [
    ./niri
    ./dunst.nix
    ./fuzzel.nix
    ./swayosd.nix
    ./wallpaper.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    # music
    playerctl

    # clipboard history
    cliphist
    wl-clipboard

    # screencast
    wl-screenrec
    procps
  ];

  services.playerctld = {
    enable = true;
    package = pkgs.playerctl;
  };
}
