{inputs, ...}: let
  inherit (builtins) listToAttrs;

  baseZathuraConf = {
    settings = import ./_config.nix {};
    mappings = import ./_mappigs.nix {};
  };
in {
  perSystem = {pkgs, ...}: {
    packages.zathura =
      inputs.wrappers.wrappers.zathura.wrap ({inherit pkgs;} // baseZathuraConf);
  };

  flake.modules.nixos.gui = {pkgs, ...}: let
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "zathura";
      rev = "9f29c2c1622c70436f0e0b98fea9735863596c1e";
      hash = "sha256-upyfc4OSx9xKUoM/JdRfuXiw38ffoSB/Utm2jpyXgy8=";
    };
    catppuccin = "${src}/themes/catppuccin-frappe";
  in {
    nixpkgs.overlays = [
      (_: _prev: {
        zathura = pkgs.custom.zathura.wrap (
          baseZathuraConf
          // {
            extraSettings = ''
              include ${catppuccin}
            '';
          }
        );
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
        ''cat "${confPath}" "${catppuccin}" | moor'';
    };
  };
}
