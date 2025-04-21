{
  lib,
  config,
  pkgs,
  ...
}:
let
  spot_id = "dev.alextren.Spot";
in
{
  options.custom = with lib; {
    spot = {
      enable = mkEnableOption "Native Spotify client for the GNOME desktop";
    };
  };

  config = lib.mkIf config.custom.spot.enable {
    home.packages = with pkgs; [
      spot
    ];

    custom.persist = {
      home.directories = [
        ".cache/spot"
      ];
    };
  };
}
