_: {
  imports = [
    ./desktop
    ./shell
    ./btop.nix
    ./eza.nix
    ./fastfetch.nix
    ./gh.nix
    ./git.nix
    ./jujutsu.nix
    ./lazygit.nix
    ./mpd.nix
    ./neovim.nix
    ./nix.nix
    ./ripgrep.nix
    ./starship.nix
    ./terminal.nix
    ./tldr.nix
    ./yt-dlp.nix
    ./zoxide.nix
  ];

  services.playerctld.enable = true;
}
