{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: {
    packages.btop = config.flake.custom.wrappers.mkBtop {
      inherit pkgs;
    };
  };

  flake.custom.wrappers = let
    toBtopConf = lib.generators.toKeyValue {
      mkKeyValue = lib.generators.mkKeyValueDefault {
        mkValueString = v:
          if builtins.isBool v
          then
            (
              if v
              then "True"
              else "False"
            )
          else if builtins.isString v
          then ''"${v}"''
          else toString v;
      } " = ";
    };
  in {
    mkBtopConfig = {
      pkgs,
      extraConfig ? {},
    }:
      pkgs.writeTextFile {
        name = "wrapped-btop.conf";
        text = toBtopConf (import ./_config.nix {} // extraConfig);
      };

    mkBtop = {
      pkgs,
      pkg ? pkgs.btop,
      extraConfig ? {},
    }: let
      cfg = config.flake.custom.wrappers.mkBtopConfig {
        inherit pkgs extraConfig;
      };

      customTheme = import ./_theme.nix {inherit pkgs;};

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "btop-print-config";
        lang = "ini";
      };
    in
      pkgs.symlinkJoin {
        name = "btop";
        paths = [pkg];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          ln -s ${customTheme} $out/share/btop/themes/catppuccin-frappe.theme

          wrapProgram $out/bin/btop \
            --add-flags "--config ${cfg}" \
            --add-flags "--themes-dir $out/share/btop/themes"
        '';
        meta.mainProgram = "btop";
      };
  };
}
