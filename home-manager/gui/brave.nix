{
  lib,
  pkgs,
  ...
}:
lib.mkMerge [
  {
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

    # set default browser
    home.sessionVariables = {
      DEFAULT_BROWSER = lib.getExe pkgs.brave;
      BROWSER = lib.getExe pkgs.brave;
    };
  }

  {
    xdg.mimeApps.defaultApplications = {
      "text/html" = "brave.desktop";
      "x-scheme-handler/http" = "brave.desktop";
      "x-scheme-handler/https" = "brave.desktop";
      "x-scheme-handler/about" = "brave.desktop";
      "x-scheme-handler/unknown" = "brave.desktop";
    };
  }

  {
    custom.persist = {
      home.directories = [
        ".cache/BraveSoftware"
        ".config/BraveSoftware"
      ];
    };
  }
]
