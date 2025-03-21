{ pkgs, self, ... }:
{
  imports = [
    ./niri
    ./rofi
    ./dunst.nix
    ./swayosd.nix
    ./waybar.nix
  ];

  home = {
    packages =
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
      ]
      ++ (with self.packages.${pkgs.system}; [
        # show info in hyprlock
        hypr-scripts
        screencast
      ]);
  };
}
