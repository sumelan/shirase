{lib, ...}: let
  inherit (lib) getExe;
in {
  flake.modules.nixos.default = {pkgs, ...}: let
    starshipConf = import ./_config.nix {inherit lib pkgs;};
    starshipExe = getExe pkgs.starship;
  in {
    programs = {
      bash = {
        promptInit =
          # sh
          ''
            if [[ $TERM != "dumb" ]]; then
              export STARSHIP_CONFIG=${starshipConf}
              eval "$(${starshipExe} init bash)"
            fi
          '';
      };

      fish = {
        # fix starship prompt to only have newlines after the first command
        # https://github.com/starship/starship/issues/560#issuecomment-1465630645
        promptInit =
          # fish
          ''
            if test "$TERM" != dumb
              # not sure why this needs to be explicitly set, but wrapping alone does not seem sufficient
              set -x STARSHIP_CONFIG ${starshipConf}
              eval (${starshipExe} init fish)
              enable_transience
            end

            function prompt_newline --on-event fish_postexec
              echo ""
            end

            function starship_transient_prompt_func
              ${starshipExe} module character
            end
          '';
      };
    };
  };
}
