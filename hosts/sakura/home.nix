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
        run --quiet ${swww} img -o DP-1 "$HOME/Pictures/Wallpapers/DP-1.png"
      '';
  };

  custom = {
    waybar.hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
    easyEffects = {
      enable = true;
      preset = "Bass Enhancing + Perfect EQ";
    };
  };
}
