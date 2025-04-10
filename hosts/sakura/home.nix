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
    "HDMI-A-2" = {
      scale = 1.30;
      mode = {
        width = 2560;
        height = 1600;
        refresh = 60.000;
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
    psst.enable = true;
    thunderbird.enable = true;
    easyEffects = {
      enable = true;
      preset = "Bass Enhancing + Perfect EQ";
    };
  };
}
