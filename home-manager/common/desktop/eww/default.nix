{ pkgs, ... }:
{
  programs.eww = {
    enable = true;
    package = pkgs.eww;
    enableBashIntegration = true;
    enableFishIntegration = true;
    #  configDir = ./components;
  };
}
