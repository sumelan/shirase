{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: let
    catppuccin = let
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "zathura";
        rev = "9f29c2c1622c70436f0e0b98fea9735863596c1e";
        hash = "sha256-upyfc4OSx9xKUoM/JdRfuXiw38ffoSB/Utm2jpyXgy8=";
      };
    in "${src}/themes/catppuccin-frappe";
    extraConfig = ''
      include ${catppuccin}

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
