{
  pkgs,
  lib,
  config,
  wallpapers,
  ...
}: let
  goNord =
    pkgs.writers.writePython3Bin "goNord" {
      libraries = with pkgs.python3Packages; [image-go-nord pyyaml];
    } ''
      from ImageGoNord import GoNord
      import argparse
      import yaml

      parser = argparse.ArgumentParser(description="Go nord")
      parser.add_argument(
          "--colorscheme",
          "-c",
          help="Path to the yaml file containing the colorscheme"
      )
      parser.add_argument(
          "--image",
          "-i",
          help="Path to the image to quantize")
      parser.add_argument(
          "--output",
          "-o",
          help="Path to the output image",
          default="output.png"
      )
      args = parser.parse_args()
      colorscheme = args.colorscheme
      image = args.image
      output = args.output

      go_nord = GoNord()
      go_nord.enable_avg_algorithm()
      go_nord.enable_gaussian_blur()
      image = go_nord.open_image(image)
      if colorscheme:
          go_nord.reset_palette()
          palette = set(
            yaml.safe_load(open(colorscheme))["palette"].values()
          )
          for color in palette:
              go_nord.add_color_to_palette(color)
      go_nord.quantize_image(image, save_path=output)
    '';
  generateWallpaper = monitor: wallpaper: let
    inherit (wallpaper) path convertMethod;
  in
    if convertMethod == "gonord"
    then
      pkgs.runCommand "${monitor}.png" {} ''
        ${goNord}/bin/goNord -c ${config.stylix.base16Scheme} -i ${path} -o $out
      ''
    else if convertMethod == "lutgen"
    then let
      inherit (config.lib.stylix.colors) base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F;
    in
      pkgs.runCommand "${monitor}.png" {} ''
        ${pkgs.lutgen}/bin/lutgen apply -o $out ${path} -- \
          ${base00} ${base01} ${base02} ${base03} ${base04} ${base05} \
          ${base06} ${base07} ${base08} ${base09} ${base0A} ${base0B} \
          ${base0C} ${base0D} ${base0E} ${base0F}
      ''
    else path;
  generatedWallpapers = builtins.mapAttrs generateWallpaper wallpapers;
  setWallpaper = monitor: wallpaper: {
    target = "Pictures/Wallpapers/${monitor}.png";
    source = wallpaper;
  };
  blurWallpaper = monitor: wallpaper: {
    name = "${monitor}-blurred";
    value = {
      target = "Pictures/Wallpapers/${monitor}-blurred.png";
      source = pkgs.runCommand "${monitor}-blurred.png" {} ''
        ${pkgs.imagemagick}/bin/magick ${wallpaper} -blur 0x10 $out
      '';
    };
  };
in {
  imports = [
    ./blur.nix
  ];

  home.file =
    builtins.mapAttrs setWallpaper generatedWallpapers
    // lib.attrsets.mapAttrs' blurWallpaper generatedWallpapers;

  programs.niri.settings.spawn-at-startup = [
    {command = ["swww-daemon"];}
  ];
}
