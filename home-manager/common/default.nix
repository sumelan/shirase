_: {
  imports = [
    ./desktop
    ./neovim
    ./scripts
    ./shell
    ./btop.nix
    ./cava.nix
    ./eza.nix
    ./fastfetch.nix
    ./gh.nix
    ./git.nix
    ./jujutsu.nix
    ./lazygit.nix
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
