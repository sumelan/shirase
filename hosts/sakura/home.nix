{
  lib,
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
  })
  {
    custom = {
      amberol.enable = true;
      easyEffects = {
        enable = true;
        preset = "Bass Enhancing + Perfect EQ";
      };
      foliate.enable = true;
      ghostty.enable = false;
      inkscape.enable = true;
      krita.enable = true;
      rustdesk.enable = true;
      thunderbird.enable = true;
      vlc.enable = true;
    };
  }
]
