{config, ...}: let
  inherit (config) flake;
  inherit (config.flake.custom.functions) printConfig;
  inherit (config.flake.custom.wrappers) mkFish;
  inherit (config.flake.custom.userModules.shellAliases) basic extra fish;
in {
  perSystem = {pkgs, ...}: let
    # dotfile of the user using fish
    dotfile = "/home/sumelan/Projects/shirase";
  in {
    packages.fish = mkFish {
      inherit pkgs;
      env = {
        NH_FLAKE = dotfile;
        NIXPKGS_ALLOW_UNFREE = "1";
      };
    };
  };
  flake.custom.wrappers.mkFish = {
    pkgs,
    env ? {},
    extraConfig ? "",
    extraAliases ? {},
    extraRuntimeInputs ? [],
  }: let
    aliases = basic // extra // fish // extraAliases;

    cfg = import ./_config.nix {
      inherit
        pkgs
        flake
        env
        extraConfig
        aliases
        ;
    };

    print = printConfig {
      inherit cfg pkgs;
      lang = "fish";
      name = "fish-print-config";
    };

    runtimeEnv = pkgs.buildEnv {
      name = "fish-runtime-env";
      pathsToLink = ["/bin"];
      paths = with pkgs;
        [
          bat
          direnv
          eza
          fd
          fzf
          jq
          nix-direnv
          starship
          git
          ripgrep
          delta
          tig
          lazygit
        ]
        ++ extraRuntimeInputs;
    };
  in
    pkgs.symlinkJoin {
      name = "fish";
      paths = [pkgs.fish];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        cp -r ${print}/bin $out

        wrapProgram $out/bin/fish \
          --add-flags "--init-command 'source ${cfg}'" \
          --prefix PATH : ${runtimeEnv}/bin
      '';
      passthru.shellPath = "/bin/fish";
      meta.mainProgram = "fish";
    };
}
