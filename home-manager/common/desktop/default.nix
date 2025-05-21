{ pkgs, self, ... }:
{
  imports = [
    ./niri
    ./fnott.nix
    ./fuzzel.nix
    ./image.nix
    ./nautilus.nix
    ./swayosd.nix
    ./wallpaper.nix
    ./waybar.nix
  ];

  home.packages =
    with pkgs;
    [
      #backlight
      brightnessctl

      # music
      playerctl

      # clipboard
      wl-clipboard
      cliphist

      #screen-record
      wl-screenrec
    ]
    ++ [
      # custom packages
      self.packages.${pkgs.system}.screencast
      self.packages.${pkgs.system}.update-checker
    ];

  services.playerctld = {
    enable = true;
    package = pkgs.playerctl;
  };
}
