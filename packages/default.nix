{ pkgs, ... }:
{
  grub-theme = pkgs.callPackage ./grub-theme { };
  tela-dynamic-icon-theme = pkgs.callPackage ./tela-dynamic-icon-theme { };
}
