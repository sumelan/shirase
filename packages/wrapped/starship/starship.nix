{config, ...}: let
  inherit (config.flake.custom.wrappers) mkStarshipConfig mkStarship;
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: {
    packages.starship = mkStarship {inherit pkgs;};
  };

  flake.custom.wrappers = {
    mkStarshipConfig = {
      pkgs,
      extraConfig ? {},
      nf-icon ? "󰟆 ",
    }:
      import ./_config.nix {inherit pkgs extraConfig nf-icon;};

    mkStarship = {
      pkgs,
      extraConfig ? {},
      nf-icon ? "󰟆 ",
    }: let
      cfg = mkStarshipConfig {inherit pkgs extraConfig nf-icon;};

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "starship-print-config";
      };
    in
      pkgs.symlinkJoin {
        name = "starship";
        paths = [pkgs.starship];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          wrapProgram $out/bin/starship \
            --set STARSHIP_CONFIG ${cfg}
        '';
      };
  };
}
