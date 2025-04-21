{ pkgs, ... }:
{
  imports = [
    ./niri
    ./dunst.nix
    ./fuzzel.nix
    ./swayosd.nix
    ./waybar.nix
  ];

  home.packages =
    with pkgs;
    [
      # wallpaper
      swww

      # clipboard history
      cliphist
      wl-clipboard

      # screencast
      wl-screenrec
      procps
    ]
    ++ [
      (import ./wallsetter.nix { inherit pkgs; })
    ];
}
