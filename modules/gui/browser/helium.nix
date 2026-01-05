{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.helium = {pkgs, ...}: {
    programs.chromium = {
      enable = true;
      package = flake.packages.${pkgs.stdenv.hostPlatform.system}.helium;
    };

    xdg.mimeApps = let
      value = "helium.desktop";
      imgAssociations = builtins.listToAttrs (map (name: {
          inherit name value;
        }) [
          "image/jpeg"
          "image/gif"
          "image/webp"
          "image/png"
        ]);
    in {
      # remove `helium.desktop` from image mimetypes
      associations.removed = imgAssociations;
    };

    custom.persist.home.directories = [
      ".cache/net.imput.helium"
      ".config/net.imput.helium"
    ];
  };
}
