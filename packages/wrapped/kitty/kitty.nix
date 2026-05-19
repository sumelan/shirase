{config, ...}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: let
    nord = pkgs.fetchFromGitHub {
      owner = "connorholyday";
      repo = "nord-kitty";
      rev = "3a819c1f207cd2f98a6b7c7f9ebf1c60da91c9e9";
      hash = "sha256-Zbmrp2sQO0upkQ6Gtt5O4SLzPhovUDQNjvM0x8v2a0g=";
    };
    extraConfig = {
      include = "${nord}/nord.conf";
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
