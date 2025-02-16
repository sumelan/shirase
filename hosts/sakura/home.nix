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
        "HDMI-A-1" = {
          mode = {
            width = 2560;
            height = 1440;
          };
          position = {
            x = 0;
            y = 0;
          };
          scale = 1.0;
        };
        "HDMI-A-2" = {
          mode = {
            width = 2560;
            height = 1440;
          };
          position = {
            x = 0;
            y = 1440;
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
          run --quiet ${swww} img -o HDMI-A-1 "$HOME/Pictures/Wallpapers/HDMI-A-1.png" \
            && run --quiet ${swww} img -o HDMI-A-2 "$HOME/Pictures/Wallpapers/HDMI-A-2.png"
        '';
    };
  })

  {
    custom = {
      amberol.enable = true;
      brave.enable = true;
      discord.enable = true;
      foliate.enable = true;
      ghostty.enable = true;
      rustdesk.enable = true;
      thunderbird.enable = true;
      easyEffects = {
        enable = true;
        preset = "Bass Enhancing + Perfect EQ";
      };
    };
  }
]
