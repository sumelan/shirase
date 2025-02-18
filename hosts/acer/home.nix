{
  lib,
  pkgs,
  config,
  ...
}:
lib.mkMerge [
  (lib.mkIf config.custom.niri.enable {
    programs.niri.settings = {
      outputs = {
        "eDP-1" = {
          mode = {
            width = 1920;
            height = 1200;
          };
          position = {
            x = 0;
            y = 0;
          };
          scale = 1.0;
        };
      };
    };

    home.activation = {
      reload-swww = let
        swww = "${pkgs.swww}/bin/swww";
      in
        # bash, reload wallpaper at home-manager switch
        lib.hm.dag.entryAfter ["writeBoundary"] '' 
          run --quiet ${swww} img -o eDP-1 "$HOME/Pictures/Wallpapers/eDP-1.png"
        '';
    };
  })

  {
    custom = {
      foliate.enable = true;
      thunderbird.enable = true;
      easyEffects = {
        enable = true;
        preset = "Loudness+Autogain";
      };
    };
  }
]
