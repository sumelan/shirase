{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: let
    zathura-nord = let
      src = pkgs.fetchFromGitHub {
        owner = "nautilor";
        repo = "zathura-nord";
        rev = "a1c80f8ba7c1e7ddd548d38b26458ea8e8b329cd";
        hash = "sha256-pj9/ZvN+58ZUWyGnY9Yk9EwdvWRH5hY2BZp2TGDpi+g=";
      };
    in "${src}/zathurarc";
    extraConfig = ''
      include ${zathura-nord}
    '';
  in {
    packages.zathura = config.flake.custom.wrappers.mkZathura {
      inherit pkgs extraConfig;
    };
  };

  flake.custom.wrappers = let
    formatLine = n: v: let
      formatValue = v:
        if lib.isBool v
        then
          (
            if v
            then "true"
            else "false"
          )
        else toString v;
    in ''set ${n}	"${formatValue v}"'';

    formatMapLine = n: v: "map ${n}   ${toString v}";
  in {
    mkZathuraConfig = {
      pkgs,
      extraConfig ? "",
    }:
      pkgs.writeTextFile {
        name = "zathura";
        destination = "/zathurarc";
        text = ''
          ${lib.concatStringsSep "\n" (
            lib.mapAttrsToList formatLine (import ./_config.nix {})
            ++ lib.mapAttrsToList formatMapLine (import ./_mappings.nix {})
          )}
          ${extraConfig}
        '';
      };

    mkZathura = {
      pkgs,
      extraConfig ? "",
    }: let
      cfg = config.flake.custom.wrappers.mkZathuraConfig {
        inherit pkgs extraConfig;
      };

      printCfg = printConfig {
        inherit pkgs;
        cfg = "${cfg}/zathurarc";
        name = "zathura-print-config";
        lang = "ini";
      };
    in
      pkgs.symlinkJoin {
        name = "zathura";
        paths = [pkgs.zathura];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          wrapProgram $out/bin/zathura \
            --add-flags "--config-dir ${cfg}"
        '';
        meta.mainProgram = "zathura";
      };
  };
}
