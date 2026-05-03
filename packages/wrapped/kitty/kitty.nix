{config, ...}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: let
    catppuccin-frappe = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "kitty";
      rev = "43098316202b84d6a71f71aaf8360f102f4d3f1a";
      hash = "sha256-akRkdq8l2opGIg3HZd+Y4eky6WaHgKFQ5+iJMC1bhnQ=";
    };
    extraConfig = {
      include = "${catppuccin-frappe}/themes/frappe.conf";
    };
  in {
    packages.kitty = config.flake.custom.wrappers.mkKitty {
      inherit pkgs extraConfig;
    };
  };

  flake.custom.wrappers = {
    mkKittyConfig = {
      pkgs,
      extraBinds ? {},
      extraConfig ? {},
    }:
      import ./_config.nix {inherit pkgs extraConfig extraBinds;};

    mkKitty = {
      pkgs,
      extraConfig ? {},
      extraBinds ? {},
    }: let
      cfg = config.flake.custom.wrappers.mkKittyConfig {
        inherit pkgs extraConfig extraBinds;
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

          wrapProgram $out/bin/kitty \
            --add-flags "-c ${cfg}" \
            --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = [pkgs.maple-mono.NF-unhinted];}}
        '';
        meta.mainProgram = "kitty";
      };
  };
}
