_: {
  imports = [
    ./kitty
    ./maomaowm
    ./niri
    ./discord.nix
    ./dunst.nix
    ./easyeffects.nix
    ./fuzzel.nix
    ./librewolf.nix
    ./mpv.nix
    ./nemo.nix
    ./nixlogo.nix
    ./spicetify.nix
    ./swayimg.nix
    ./swayosd.nix
    ./yazi.nix
    ./zathura.nix
  ];

  # WM agnostic polkit authentication agent
  services.polkit-gnome.enable = true;
}
