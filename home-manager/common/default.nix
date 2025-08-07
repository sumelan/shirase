{pkgs, ...}: {
  imports = [
    ./desktop
    ./scripts
    ./shell
    ./btop.nix
    ./cava.nix
    ./eza.nix
    ./fastfetch.nix
    ./gh.nix
    ./git.nix
    ./helix.nix
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
