{ pkgs, self, ... }:
{
  imports = [
    ./niri
    ./wallpapers
    ./waybar
    ./dunst.nix
    ./fuzzel.nix
    ./swayosd.nix
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

    file = {
      # add icon image used in hyprlock
      ".face.icon".source = ./../../hosts/pfp.png;
      ".config/face.png".source = ./../../hosts/pfp.png;
    };
  };
}
