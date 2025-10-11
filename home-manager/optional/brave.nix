#NOTE: stylix.targets.chromium.enable is only available as NioxOS Options
{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.custom = {
    brave.enable = mkEnableOption "brave";
  };

  config = mkIf config.custom.brave.enable {
    programs.brave = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--enable-features=TouchpadOverscrollHistoryNavigation"
        "--ozone-platform=wayland"
      ];

      extensions = [
        # Bitwarden
        {id = "nngceckbapebfimnlniiiahkandclblb";}
        # Dark Reader
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";}
        # SponsorBlock for YouTube - Skip Sponsorships
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";}
        # uBlock Origin
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
        # Youtube-shorts block
        {id = "jiaopdjbehhjgokpphdfgmapkobbnmjp";}
      ];
    };

    programs.niri.settings.window-rules = [
      {
        matches = [
          {
            app-id = "^(brave)$";
            title = "^(Save File)$";
          }
          {
            app-id = "^(brave)$";
            title = "(.*)(wants to save)$";
          }
        ];
        open-floating = true;
        opacity = 1.0;
      }
    ];

    custom.persist = {
      home.directories = [
        ".cache/BraveSoftware"
        ".config/BraveSoftware"
      ];
    };
  };
}
