{ pkgs, self, ... }:
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
    #backlight
    brightnessctl

    # music
    playerctl

    # clipboard
    wl-clipboard
    cliphist

    #xwayland
    xwayland-satellite

    #screen-record
    wl-screenrec
    self.packages.${system}.screencast
  ];

  services.playerctld = {
    enable = true;
    package = pkgs.playerctl;
  };
}
