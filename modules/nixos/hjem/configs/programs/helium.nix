{inputs, ...}: {
  flake.custom.hjemConfigs.helium = {
    pkgs,
    user,
    ...
  }: let
    helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;
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

    hjem.users.${user} = {
      packages = builtins.attrValues {
        inherit helium;
      };

      # Add widevine support, inspired from this comment:
      # https://github.com/imputnet/helium/issues/116#issuecomment-3668370766
      xdg.config.files."net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm".text = ''
        {"Path":"${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm"}
      '';

      xdg.mime-apps = let
        value = "helium.desktop";
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
