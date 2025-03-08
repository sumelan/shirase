{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    brave.enable = mkEnableOption "brave";
  };

  config = lib.mkIf config.custom.brave.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = [ "--enable-features=TouchpadOverscrollHistoryNavigation" ];

      extensions = [
        # AutoPagerize
        { id = "igiofjhpmpihnifddepnpngfjhkfenbp"; }
        # Awesome Screen Recorder & Screenshot
        { id = "nlipoenfbbikpbjkfpfillcgkoblgpmj"; }
        # Bitwarden
        { id = "nngceckbapebfimnlniiiahkandclblb"; }
        # Dark Reader
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
        # Honey
        { id = "bmnlcjabgnpnenekpadlanbbkooimhnj"; }
        # JSON Viewer
        { id = "gbmdgpbipfallnflgajpaliibnhdgobh"; }
        # Looty
        # {id = "ajfbflclpnpbjkfibijekgcombcgehbi";}
        # React Dev Tools
        { id = "fmkadmapgofadopljbjfkapdkoienihi"; }
        # Return YouTube Dislike
        { id = "gebbhagfogifgggkldgodflihgfeippi"; }
        # Session Manager
        { id = "mghenlmbmjcpehccoangkdpagbcbkdpc"; }
        # SponsorBlock for YouTube - Skip Sponsorships
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
        # Surfingkeys
        { id = "gfbliohnnapiefjpjlpjnehglfpaknnc"; }
        # uBlock Origin
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
        # Video Speed Controller
        { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; }
        # YouTube Auto HD + FPS
        { id = "fcphghnknhkimeagdglkljinmpbagone"; }
        # Youtube-shorts block
        { id = "jiaopdjbehhjgokpphdfgmapkobbnmjp"; }
      ];
    };

    programs.niri.settings.window-rules = [
      {
        matches = [{ app-id = "^(brave)$"; }];
        default-column-width = {
          proportion = 1.0;
        };
      }
      {
        matches = [
          { app-id = "^(brave)$"; title = "^(Picture-in-Picture)$"; }
          { app-id = "^(brave)$"; title = "^(Save File)$"; }
          { app-id = "^(brave)$"; title = "(.*)(wants to save)$"; }
        ];
        open-floating = true;
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
