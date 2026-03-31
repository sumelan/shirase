_: let
  inherit (builtins) listToAttrs;
in {
  flake.modules.nixos.hjem-gui = {pkgs, ...}: {
    programs.chromium = {
      enable = true;
      extensions = [
        # Bitwarden
        "nngceckbapebfimnlniiiahkandclblb"
        # Dark Reader
        "eimadpbcbfnmbkopoojfekhnkhdbieeh"
        # kagi privacy pass
        "mendokngpagmkejfpmeellpppjgbpdaj"
        # kagi search
        "cdglnehniifkbagbbombnjghhcihifij"
        # kagi summarizer
        "dpaefegpjhgeplnkomgbcmmlffkijbgp"
        # kagi translate
        "alblebhaoakdgapamjdifdfnaicpnklm"
        # nord
        "abehfkkfjlplnjadfcjiflnejblfmmpj"
        # SponsorBlock for YouTube - Skip Sponsorships
        "mnjggcdmjocbbbhaepdhchncahnbgone"
        # YouTube Auto HD + FPS
        "fcphghnknhkimeagdglkljinmpbagone"
        # youtube no translation
        "lmkeolibdeeglfglnncmfleojmakecjb"
        # Youtube-shorts block
        "jiaopdjbehhjgokpphdfgmapkobbnmjp"
      ];
    };

    hj = {
      packages = [
        pkgs.custom.helium
      ];

      environment.sessionVariables = {
        # set default browser
        DEFAULT_BROWSER = "helium";
        BROWSER = "helium";
      };

      xdg.mime-apps = let
        value = "helium.desktop";

        defaultAssociations = listToAttrs (map (name: {
            inherit name value;
          }) [
            "x-scheme-handler/unknown"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "text/html"
          ]);

        imgAssociations = listToAttrs (map (name: {
            inherit name value;
          }) [
            "image/jpeg"
            "image/gif"
            "image/webp"
            "image/png"
            "application/pdf"
          ]);
      in {
        default-applications = defaultAssociations;
        added-associations = defaultAssociations;
        removed-associations = imgAssociations;
      };
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/net.imput.helium"
      ];
      cache.home.directories = [
        ".cache/net.imput.helium"
      ];
    };
  };
}
