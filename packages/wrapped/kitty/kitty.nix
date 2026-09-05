{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: let
    catppuccin = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "kitty";
      rev = "43098316202b84d6a71f71aaf8360f102f4d3f1a";
      hash = "sha256-akRkdq8l2opGIg3HZd+Y4eky6WaHgKFQ5+iJMC1bhnQ=";
    };
    extraConfig = {
      include = "${catppuccin}/themes/frappe.conf";
      shell = "nu";
    };

    extraRawConfig = let
      features = lib.concatStringsSep " " [
        "+calt" # default ligatures
        "+zero" # alternate zero
        "+cv62" # alternative question
        "+cv63" # alternative left arrow
        "+cv66" # alternative pipe arrows
        "+ss03" # arbitary tag
        "+ss05" # thin escape backslash
        "+ss07" # relax multi-greaters condition
        "+ss08" # double / back rows
        "+ss09" # alternative not equal
        "+ss10" # aaproximately equal
        "+ss11" # extra equal ligatures
      ];
    in ''
      font_features MapleMono-NF-Regular ${features}
      font_features MapleMono-NF-SemiBold ${features}
      font_features MapleMono-NF-Italic ${features}
      font_features MapleMono-NF-SemiBoldItalic ${features}
    '';
  in {
    packages.kitty = config.flake.custom.wrappers.mkKitty {
      inherit pkgs extraConfig extraRawConfig;
    };
  };

  flake.custom.wrappers = {
    mkKittyConfig = {
      pkgs,
      extraConfig ? {},
      extraRawConfig ? "",
      extraBinds ? {},
    }:
      import ./_config.nix {inherit pkgs extraConfig extraRawConfig extraBinds;};

    mkKitty = {
      pkgs,
      extraConfig ? {},
      extraRawConfig ? "",
      extraBinds ? {},
    }: let
      cfg = config.flake.custom.wrappers.mkKittyConfig {
        inherit pkgs extraConfig extraRawConfig extraBinds;
      };

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "kitty-print-config";
        lang = "ini";
      };
    in
      pkgs.symlinkJoin {
        name = "kitty";
        paths = [pkgs.kitty];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          rm $out/bin/.kitty-wrapped

          wrapProgram $out/bin/kitty \
            --add-flags "-c ${cfg}" \
            --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = [pkgs.maple-mono.NF-unhinted];}}
        '';
        meta.mainProgram = "kitty";
      };
  };
}
