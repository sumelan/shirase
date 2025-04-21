_: {
  monitors = {
    "HDMI-A-1" = {
      isMain = true;
      scale = 1.00;
      mode = {
        width = 2560;
        height = 1440;
        refresh = 59.951;
      };
      position = {
        x = 0;
        y = 0;
      };
      rotation = 0;
    };
    "DP-1" = {
      scale = 1.0;
      mode = {
        width = 2560;
        height = 1440;
        refresh = 59.951;
      };
      position = {
        x = 0;
        y = 1440;
      };
      rotation = 0;
    };
  };

  custom = {
    brave.enable = true;
    foliate.enable = true;
    cyanrip.enable = true;
    inkscape.enable = true;
    krita.enable = true;
    spot.enable = true;
    thunderbird.enable = true;
    easyEffects = {
      enable = true;
      preset = "Bass Enhancing + Perfect EQ.json";
    };
  };
}
