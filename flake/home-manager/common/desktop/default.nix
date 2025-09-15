_: {
  imports = [
    ./niri
    ./dimland.nix
    ./discord.nix
    ./dms.nix
    ./kitty.nix
    ./librewolf.nix
    ./mpv.nix
    ./nemo.nix
    ./pipewire.nix
    ./swayidle.nix
    ./swayimg.nix
    ./swayosd.nix
    ./yazi.nix
    ./zathura.nix
  ];

  # WM agnostic polkit authentication agent
  services.polkit-gnome.enable = true;
}
