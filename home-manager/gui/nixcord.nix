{
  lib,
  config,
  ...
}:
{
  options.custom = with lib; {
    discord.enable = mkEnableOption "discord client";
  };

  config = lib.mkIf config.custom.discord.enable {  
    programs.nixcord = {
      enable = true;  # enable Nixcord. Also installs discord package
      config = {
        frameless = true; # set some Vencord options
        plugins = {
          # Some plugin here
          # ...
          };
        };
      extraConfig = {
        # Some extra JSON config here
        # ...
      };
    # ...
    };

    custom.persist = {
      home.directories = [
        ".config/discord"
        ".config/vesktop"
      ];
    };
  };
}
