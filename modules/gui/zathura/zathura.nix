{
  lib,
  self,
  ...
}: let
  inherit (builtins) listToAttrs;
  inherit (lib) mkOption mkDefault;
  inherit (lib.types) str;

  zathuraOptions = {
    extraSettings = mkOption {
      type = str;
      default = "";
      description = ''
        Extra settings to add to {file}`zathurarc` file.
        See <https://man.archlinux.org/man/zathurarc.5> for options.
      '';
    };
  };
in {
  flake.wrappers.zathura = {
    config,
    wlib,
    ...
  }: let
    zathuraConf = import ./_config.nix {inherit config;};
  in {
    imports = [wlib.modules.default];

    options = zathuraOptions;

    config.package = mkDefault config.pkgs.zathura;
    config.flags = {
      "--config-dir" = toString zathuraConf;
    };
  };

  perSystem = {pkgs, ...}: {
    packages.zathura = (self.wrappers.zathura.apply {inherit pkgs;}).wrapper;
  };

  flake.modules = {
    nixos.default = {pkgs, ...}: let
      src = pkgs.fetchFromGitHub {
        owner = "nautilor";
        repo = "zathura-nord";
        rev = "a1c80f8ba7c1e7ddd548d38b26458ea8e8b329cd";
        hash = "sha256-pj9/ZvN+58ZUWyGnY9Yk9EwdvWRH5hY2BZp2TGDpi+g=";
      };
      zathura-nord = "${src}/zathurarc";
    in {
      options.custom = {
        programs.zathura = zathuraOptions;
      };

      config = {
        nixpkgs.overlays = [
          (_: prev: {
            zathura =
              (self.wrappers.zathura.apply {
                pkgs = prev;
                extraSettings = ''
                  include ${zathura-nord}
                '';
              }).wrapper;
          })
        ];
      };
    };
    homeManager.default = {pkgs, ...}: let
      src = pkgs.fetchFromGitHub {
        owner = "nautilor";
        repo = "zathura-nord";
        rev = "a1c80f8ba7c1e7ddd548d38b26458ea8e8b329cd";
        hash = "sha256-pj9/ZvN+58ZUWyGnY9Yk9EwdvWRH5hY2BZp2TGDpi+g=";
      };
      zathura-nord = "${src}/zathurarc";
    in {
      home.packages = [
        pkgs.zathura # overlay-ed above
      ];

      xdg.mimeApps = let
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
        associations.removed = associations;
      };
      custom.programs.print-config = {
        zathura =
          # sh
          ''cat "${
              pkgs.zathura.configuration.flags."--config-dir".data
            }/zathurarc" "${zathura-nord}" | moor'';
      };
    };
  };
}
