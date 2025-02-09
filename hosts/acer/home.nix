{
  lib,
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
  })
  {
    custom = {
      easyEffects = {
        enable = true;
        preset = "Loudness+Autogain";
      };
      foliate.enable = true;
      thunderbird.enable = true;
    };
  }
]
