{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    helium.enable = mkEnableOption "Helium Browser";
  };

  config = mkIf config.custom.helium.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.custom.helium;
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

    custom.persist = {
      home.directories = [
        ".cache/net.imput.helium"
        ".config/net.imput.helium"
      ];
    };
  };
}
