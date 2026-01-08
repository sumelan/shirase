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
      associations = builtins.listToAttrs (map (name: {
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
      associations.removed = associations;
    };

    custom.persist.home.directories = [
      ".cache/net.imput.helium"
      ".config/net.imput.helium"
    ];
  };
}
