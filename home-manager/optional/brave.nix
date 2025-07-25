{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = {
    brave.enable = lib.mkEnableOption "brave";
  };

  config = lib.mkIf config.custom.brave.enable {
    programs.brave = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--enable-features=TouchpadOverscrollHistoryNavigation"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"
      ];

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
        matches = lib.singleton {
          app-id = "^(brave-browser)$";
        };
        default-column-width = {
          proportion = 0.6;
        };
      }
      {
        matches = [
          {
            app-id = "";
            title = "^(ピクチャー イン ピクチャー)$";
          }
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
      }
    ];

    #NOTE: stylix.targets.chromium.enable is only available as NioxOS Options

    custom.persist = {
      home.directories = [
        ".cache/BraveSoftware"
        ".config/BraveSoftware"
      ];
    };
  };
}
