_: let
  inherit (builtins) listToAttrs;
in {
  flake.modules.homeManager.default = {pkgs, ...}: {
    home.packages = [
      pkgs.loupe
    ];

    xdg.mimeApps = let
      value = "org.gnome.Loupe.desktop";
      associations = listToAttrs (map (name: {
          inherit name value;
        }) [
          "image/jpeg"
          "image/gif"
          "image/webp"
          "image/png"
        ]);
    in {
      defaultApplications = associations;
    };
  };
}
