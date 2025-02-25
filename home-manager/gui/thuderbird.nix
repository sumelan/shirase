{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    thunderbird.enable = mkEnableOption "thunderbird";
  };

  config = lib.mkIf config.custom.thunderbird.enable {
    home.packages = [ pkgs.thunderbird ];

    custom.persist = {
      home.directories = [
        ".thunderbird"
      ];
    };
  };
}
