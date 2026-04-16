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
      owner = "eastack";
      repo = "zathura-gruvbox";
      rev = "0fbb6c94b5bcc8250e6edd4981f4f4991d28b94e";
      hash = "sha256-yxoUPRWDhFqSh93qGPmxPhyKbmsZ3oY7yk4yDVUF5mE=";
    };
    gruvbox-dark-soft = "${src}/zathura-gruvbox-dark-soft";
  in {
    nixpkgs.overlays = [
      (_: prev: {
        zathura = self.wrappers.zathura.wrap {
          pkgs = prev;
          extraSettings = ''
            include ${gruvbox-dark-soft}
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
        ''cat "${confPath}" "${gruvbox-dark-soft}" | moor'';
    };
  };
}
