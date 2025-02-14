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
  })

  {
    custom = {
      amberol.enable = true;
      brave.enable = true;
      discord.enable = true;
      easyEffects = {
        enable = true;
        preset = "Bass Enhancing + Perfect EQ";
      };
      foliate.enable = true;
      rustdesk.enable = true;
      thunderbird.enable = true;
    };
  }
]
