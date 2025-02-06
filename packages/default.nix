{ pkgs, ... }:
{

  distro-grub-themes-nixos = pkgs.callPackage ./distro-grub-themes-nixos { };

  rofi-wifi-menu = pkgs.callPackage ./rofi-wifi-menu { };
}
