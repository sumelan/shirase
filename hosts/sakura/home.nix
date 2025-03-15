{
  lib,
  pkgs,
  ...
}:
{
  monitors = {
    "HDMI-A-1" = {
      isMain = true;
      scale = 1.0;
      mode = {
        width = 2560;
        height = 1440;
        refresh = 60.0;
      };
      position = {
        x = 0;
        y = 0;
      };
      rotation = 0;
    };
  };

  home.activation = {
    reload-swww =
      let
        swww = "${pkgs.swww}/bin/swww";
      in
      # bash, reload wallpaper at home-manager switch
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run --quiet ${swww} img -o HDMI-A-1 "$HOME/Pictures/Wallpapers/HDMI-A-1.png"
      '';
  };

  custom = {
    easyEffects = {
      enable = true;
      preset = "Loudness+Autogain";
    };
  };
}
