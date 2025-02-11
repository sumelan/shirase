{
  lib,
  config,
  pkgs,
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
        "DP-1" = {
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
    # run when activating a Home Manager generation
    home.activation = {
      reload-swww = let
        swww = "${pkgs.swww}/bin/swww";
      in
        lib.hm.dag.entryAfter ["writeBoundary"]
        /*
        bash
        */
        ''
          run --quiet ${swww} img -o HDMI-A-1 "$HOME/Pictures/Wallpapers/HDMI-A-1.jpg" \
            && run --quiet ${swww} img -o DP-1 "$HOME/Pictures/Wallpapers/DP-1.jpg"
        '';
      };
  })
  {
    custom = {
      amberol.enable = true;
      easyEffects = {
        enable = true;
        preset = "Bass Enhancing + Perfect EQ";
      };
      foliate.enable = true;
      inkscape.enable = true;
      krita.enable = true;
      rustdesk.enable = true;
      thunderbird.enable = true;
    };
  }
]
