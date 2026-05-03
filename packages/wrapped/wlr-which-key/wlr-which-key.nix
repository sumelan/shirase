{config, ...}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: let
    extraConfig = {};
  in {
    packages.wlr-which-key = config.flake.custom.wrappers.mkWlr {
      inherit pkgs extraConfig;
    };
  };

  flake.custom.wrappers = {
    mkWlrConfig = {
      pkgs,
      extraConfig ? {},
    }: let
      yamlFmt = pkgs.formats.yaml {};
      cfg = import ./_config.nix {};
    in
      yamlFmt.generate "wrapped-wlr_which_key.yaml" (cfg // extraConfig);

    mkWlr = {
      pkgs,
      extraConfig ? {},
    }: let
      cfg = config.flake.custom.wrappers.mkWlrConfig {
        inherit pkgs extraConfig;
      };

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "wlr-which-key-print-config";
        lang = "yaml";
      };
    in
      pkgs.symlinkJoin {
        name = "wlr-which-key";
        paths = [pkgs.wlr-which-key];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          wrapProgram $out/bin/wlr-which-key \
             --add-flags ${cfg}
        '';
        meta.mainProgram = "wlr-which-key";
      };
  };
}
