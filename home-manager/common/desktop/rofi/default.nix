{ lib, pkgs, ... }:
{
  imports = [
    ./rofi.nix
    ./system-theme.nix
  ];

  home.packages = [
    (import ./rofi-powermenu.nix { inherit lib pkgs; })
  ];
}
