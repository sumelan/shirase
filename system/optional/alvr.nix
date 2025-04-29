{
  lib,
  config,
  pkgs,
  user,
  ...
}:
{
  options.custom = with lib; {
    alvr.enable = mkEnableOption "alvr" // {
      default = config.custom.steam.enable;
    };
  };

  config = lib.mkIf config.custom.alvr.enable {
    programs = {
      alvr = {
        enable = true;
        package = pkgs.alvr;
        openFirewall = true;
      };
      adb = {
        enable = true;
      };
    };
    users.users.${user}.extraGroups = [ "adbusers" ];

    custom.persist = {
      home.directories = [
        ".config/alvr"
      ];
    };
  };
}
