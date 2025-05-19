{ pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    package = pkgs.lazygit;
    settings = { };
  };
}
