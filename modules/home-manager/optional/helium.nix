{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    helium.enable = mkEnableOption "Helium";
  };

  config = mkIf config.custom.helium.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.custom.helium;
    };

    # remove `helium.desktop` from image mimetypes
    xdg.mimeApps = let
      value = "helium.desktop";
      associations = builtins.listToAttrs (map (name: {
          inherit name value;
        }) [
          "image/jpeg"
          "image/gif"
          "image/webp"
          "image/png"
        ]);
    in {
      associations.removed = associations;
    };

    custom.persist = {
      home.directories = [
        ".cache/net.imput.helium"
        ".config/net.imput.helium"
      ];
    };
  };
}
