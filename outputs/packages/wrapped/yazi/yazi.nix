{config, ...}: {
  perSystem = {pkgs, ...}: let
    yaziConf = import ./_config.nix {inherit config pkgs;};
  in {
    packages.yazi =
      (pkgs.yazi.override {
        inherit (yaziConf) initLua plugins settings flavors;
        extraPackages = builtins.attrValues {
          inherit
            (pkgs)
            ripdrag # Drag and Drop utilty written in Rust and GTK4
            unar
            exiftool
            ;
        };
      }).overrideAttrs
      {
        passthru = {
          inherit (yaziConf) settings;
        };
      };
  };
}
