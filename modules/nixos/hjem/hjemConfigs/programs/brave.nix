_: {
  flake.custom.hjemConfigs.brave = {
    pkgs,
    user,
    ...
  }: {
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
        # catppuccin-frappe
        "olhelnoplefjdmncknfphenjclimckaf"
        # SponsorBlock for YouTube - Skip Sponsorships
        "mnjggcdmjocbbbhaepdhchncahnbgone"
        # YouTube Auto HD + FPS
        "fcphghnknhkimeagdglkljinmpbagone"
        # youtube no translation
        "lmkeolibdeeglfglnncmfleojmakecjb"
        # Youtube-shorts block
        "jiaopdjbehhjgokpphdfgmapkobbnmjp"
      ];
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://kagi.com/search?q=%s";
      defaultSearchProviderSuggestURL = "https://kagi.com/api/autosuggest?q=%s";
    };

    hjem.users.${user} = {
      packages = builtins.attrValues {
        inherit (pkgs) brave-origin;
      };

      xdg = {
        mime-apps = let
          value = "brave-origin.desktop";
          default-applications = builtins.listToAttrs (map (name: {
              inherit name value;
            }) [
              "x-scheme-handler/unknown"
              "x-scheme-handler/about"
              "x-scheme-handler/https"
              "x-scheme-handler/http"
              "text/html"
            ]);
          added-associations = builtins.listToAttrs (map (name: {
              inherit name value;
            }) [
              "x-scheme-handler/unknown"
              "x-scheme-handler/about"
              "x-scheme-handler/https"
              "x-scheme-handler/http"
              "text/html"
            ]);

          removed-associations = builtins.listToAttrs (map (name: {
              inherit name value;
            }) [
              "image/jpeg"
              "image/gif"
              "image/webp"
              "image/png"
              "application/pdf"
            ]);
        in {
          inherit
            default-applications
            added-associations
            removed-associations
            ;
        };
      };
    };

    environment.sessionVariables = {
      DEFAULT_BROWSER = "brave-origin";
      BROWSER = "brave-origin";
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/BraveSoftware"
      ];

      cache.home.directories = [
        ".cache/BraveSoftware"
      ];
    };
  };
}
