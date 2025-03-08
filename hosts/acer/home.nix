{
  lib,
  pkgs,
  ...
}:
{
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

  home.activation = {
    reload-swww = let
      swww = "${pkgs.swww}/bin/swww";
    in
      # bash, reload wallpaper at home-manager switch
      lib.hm.dag.entryAfter ["writeBoundary"] '' 
        run --quiet ${swww} img -o eDP-1 "$HOME/Pictures/Wallpapers/eDP-1.png"
      '';
  };

  custom = {
    brave.enable = true;
    foliate.enable = true;
    cyanrip.enable = true;
    thunderbird.enable = true;
    easyEffects = {
      enable = true;
      preset = "Loudness+Autogain";
    };
  };
}
