_: let
  inherit (builtins) listToAttrs;
in {
  flake.modules.nixos.gui = {pkgs, ...}: {
    hj = {
      packages = [
        pkgs.loupe
      ];

      xdg.mime-apps = let
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
        default-applications = associations;
      };
    };
  };
}
