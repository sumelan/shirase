{config, ...}: {
  flake.custom.hjemConfigs.helium = {pkgs, ...}: let
    inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) helium;
  in {
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
    };

    hj = {
      packages = [helium];

      # Add widevine support, inspired from this comment:
      # https://github.com/imputnet/helium/issues/116#issuecomment-3668370766
      xdg.config.files."net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm".text = ''
        {"Path":"${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm"}
      '';

      xdg.mime-apps = let
        value = "helium.desktop";

        defaultAssociations = builtins.listToAttrs (map (name: {
            inherit name value;
          }) [
            "x-scheme-handler/unknown"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "text/html"
          ]);

        imgAssociations = builtins.listToAttrs (map (name: {
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
