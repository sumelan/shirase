_: {
  monitors = {
    "HDMI-A-1" = {
      isMain = true;
      scale = 1.25;
      mode = {
        width = 3840;
        height = 2160;
        refresh = 60.000;
      };
      position = {
        x = 0;
        y = 0;
      };
      rotation = 0;
    };
    "HDMI-A-2" = {
      scale = 1.25;
      mode = {
        width = 2560;
        height = 1600;
        refresh = 60.000;
      };
      position = {
        x = 1843;
        y = 1728;
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
