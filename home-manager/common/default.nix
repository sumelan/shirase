{pkgs, ...}: {
  imports = [
    ./desktop
    ./neovim
    ./shell
    ./btop.nix
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

  home.packages = with pkgs; [
    wl-clipboard
  ];

  services.playerctld.enable = true;
}
