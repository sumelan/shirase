{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    discord.enable = mkEnableOption "discord client" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.discord.enable {
    home.packages = with pkgs; [
      webcord
    ];

    custom.persist = {
      home.directories = [
        ".config/WebCord"
      ];
    };
  };
}
