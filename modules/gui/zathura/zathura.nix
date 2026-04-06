{self, ...}: let
  inherit (builtins) listToAttrs;
in {
  flake.wrappers.zathura = {
    wlib,
    pkgs,
    ...
  }: {
    imports = [wlib.wrapperModules.zathura];

    settings = import ./_config.nix {};
    mappings = import ./_mappigs.nix {};
    plugins = builtins.attrValues {
      inherit
        (pkgs.zathuraPkgs)
        zathura_cb
        zathura_djvu
        zathura_ps
        zathura_pdf_mupdf
        ;
    };
  };

  flake.modules.nixos.gui = {pkgs, ...}: let
    src = pkgs.fetchFromGitHub {
      owner = "nautilor";
      repo = "zathura-nord";
      rev = "a1c80f8ba7c1e7ddd548d38b26458ea8e8b329cd";
      hash = "sha256-pj9/ZvN+58ZUWyGnY9Yk9EwdvWRH5hY2BZp2TGDpi+g=";
    };
    zathura-nord = "${src}/zathurarc";
  in {
    nixpkgs.overlays = [
      (_: prev: {
        zathura = self.wrappers.zathura.wrap {
          pkgs = prev;
          extraSettings = ''
            include ${zathura-nord}
          '';
        };
      })
    ];

    hj = {
      packages = [
        pkgs.zathura # overlay-ed above
      ];

      xdg.mime-apps = let
        value = "org.pwmt.zathura-pdf-mupdf.desktop";
        associations = listToAttrs (map (name: {
            inherit name value;
          }) [
            "image/jpeg"
            "image/gif"
            "image/webp"
            "image/png"
          ]);
      in {
        removed-associations = associations;
      };
    };

    custom.programs.print-config = let
      confPath = pkgs.zathura.configuration.constructFiles.renderedRc.outPath;
    in {
      zathura =
        # sh
        ''cat "${confPath}" "${zathura-nord}" | moor'';
    };
  };
}
