{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
  inherit (lib) getExe;
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

      environment = {
        systemPackages = [helium];
        sessionVariables = {
          # set default browser
          DEFAULT_BROWSER = getExe helium;
          BROWSER = getExe helium;
        };
      };

      custom.persist.home.directories = [
        ".cache/net.imput.helium"
        ".config/net.imput.helium"
      ];
    };

    homeManager.default = _: {
      xdg.mimeApps = let
        value = "helium.desktop";
        associations = listToAttrs (map (name: {
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
        associations.added = associations;
        defaultApplications = associations;
        # remove `helium.desktop` from mimetypes
        associations.removed = imgAssociations;
      };
    };
  };
}
