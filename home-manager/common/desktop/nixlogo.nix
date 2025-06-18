{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (config.lib.stylix.colors)
    base00
    base01
    base02
    base03
    base04
    base05
    base06
    base07
    base08
    base09
    base0A
    base0B
    base0C
    base0D
    base0E
    base0F
    ;
  logo = ../../../hosts/logo.png;
  cirno = ../../../hosts/cirno.png;
  changeColor =
    image:
    pkgs.runCommand "themed-logo.png" { } ''
      ${lib.getExe pkgs.lutgen} apply -o $out ${image} -- \
      ${base00} ${base01} ${base02} ${base03} ${base04} ${base05} \
      ${base06} ${base07} ${base08} ${base09} ${base0A} ${base0B} \
      ${base0C} ${base0D} ${base0E} ${base0F}
    '';
  setImage =
    imageA: imageB:
    pkgs.runCommand "anime-logo.png" { } ''
      ${lib.getExe pkgs.imagemagick} composite -gravity center ${imageA} ${imageB} $out
    '';
in
{
  home.file.".anime-logo.png".source = setImage cirno (changeColor logo);
}
