{ pkgs, self, ... }:
{
  imports = [
    ./eww
    ./niri
    ./rofi
    ./dunst.nix
    ./swayosd.nix
    ./waybar.nix
  ];

  home.packages =
    with pkgs;
    [
      # wallpaper
      swww

      # clipboard history
      clipman
      wl-clipboard

    ]
    ++ [
      (import ./wallsetter.nix { inherit pkgs; })
    ]
    ++ (with self.packages.${pkgs.system}; [
      # show info in hyprlock
      hypr-scripts
    ]);
}
