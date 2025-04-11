_: {
  monitors = {
    "eDP-1" = {
      isMain = true;
      scale = 1.0;
      mode = {
        width = 1920;
        height = 1200;
        refresh = 60.0;
      };
      position = {
        x = 0;
        y = 0;
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
      preset = "Loudness+Autogain.json";
    };
  };
}
