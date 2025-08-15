_: {
  imports = [
    ./common
    ./niri
    ./discord.nix
    ./dunst.nix
    ./fuzzel.nix
    ./kitty.nix
    ./librewolf.nix
    ./mpv.nix
    ./nemo.nix
    ./pipewire.nix
    ./swayimg.nix
    ./swayosd.nix
    ./yazi.nix
    ./zathura.nix
  ];

  # WM agnostic polkit authentication agent
  services.polkit-gnome.enable = true;
}
