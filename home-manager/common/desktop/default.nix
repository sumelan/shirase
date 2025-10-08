_: {
  imports = [
    ./niri
    ./discord.nix
    ./foot.nix
    ./librewolf.nix
    ./mpv.nix
    ./nemo.nix
    ./noctalia.nix
    ./pipewire.nix
    ./swayidle.nix
    ./swayimg.nix
    ./swayosd.nix
    ./yazi.nix
    ./zathura.nix
  ];

  # WM agnostic polkit authentication agent
  services.polkit-gnome.enable = true;

  home.file = {
    ".wall.png".source = ./bokutai.png;
  };
}
