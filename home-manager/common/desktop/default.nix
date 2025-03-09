{ pkgs, self, ... }:
{
  imports = [
    ./niri
    ./wallpapers
    ./dunst.nix
    ./fuzzel.nix
    ./swayosd.nix
    ./waybar.nix
  ];

  home = {
    packages = with pkgs; [
      # wallpaper
      swww

      # clipboard history
      cliphist
      wl-clipboard

      # screencast
      wl-screenrec
      procps
    ]
    ++ (
      with self.packages.${pkgs.system}; [
        # show info in hyprlock
        hypr-scripts
        screencast
      ]
    );
  };
}
