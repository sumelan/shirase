{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    discord.enable = mkEnableOption "discord client" //{
      default = true;
    };
  };

  config = lib.mkIf config.custom.discord.enable {
    home.packages = with pkgs; [
      discord
    ];

    custom.persist = {
      home.directories = [
        ".config/discord"
        ".config/Vencord"
        ".config/vesktop"
      ];
    };
  };
}
