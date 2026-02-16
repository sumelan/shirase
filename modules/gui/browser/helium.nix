{config, ...}: let
  inherit (config) flake;
  inherit (builtins) listToAttrs;
in {
  flake.modules = {
    nixos.default = {pkgs, ...}: let
      inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) helium;
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

      environment.systemPackages = [helium];

      custom.persist.home.directories = [
        ".cache/net.imput.helium"
        ".config/net.imput.helium"
      ];
    };

    homeManager.default = _: {
      xdg.mimeApps = let
        value = "helium.desktop";
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
        # remove `helium.desktop` from mimetypes
        associations.removed = imgAssociations;
      };
    };
  };
}
