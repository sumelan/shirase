_: {
  flake.modules.homeManager.default = {
    config,
    pkgs,
    ...
  }: let
    proj_dir = "/persist${config.home.homeDirectory}/Projects";
  in {
    # fish plugins, home-manager's programs.fish.plugins has a weird format
    home.packages = builtins.attrValues {
      # do not add failed commands to history
      inherit (pkgs.fishPlugins) sponge;
    };

    programs = {
      fish = {
        enable = true;
        functions = {
          # use vi key bindings with hybrid emacs keybindings
          fish_user_key_bindings =
            # fish
            ''
              fish_default_key_bindings -M insert
              fish_vi_key_bindings --no-erase insert
            '';
          pj =
            # fish
            ''
              cd ${proj_dir}
              if test (count $argv) -eq 1
                cd $argv[1]
              end
            '';
        };
        # use abbreviations instead of aliases
        preferAbbrs = true;
        # seems like shell abbreviations take precedence over aliases
        shellAbbrs =
          config.home.shellAliases
          // {
            ehistory = "nvim ${config.xdg.dataHome}/fish/fish_history";
          };
        shellInit = ''
          set fish_greeting

          # set options for plugins
          set sponge_regex_patterns 'password|passwd'

          # bind --mode default \t complete-and-search
        '';
        # setup vi mode
        interactiveShellInit = ''
          fish_vi_key_bindings
        '';
      };
    };

    # fish completion
    xdg.configFile."fish/completions/pj.fish".text =
      # fish
      ''
        function _pj
          find ${proj_dir} -maxdepth 1 -type d -exec basename {} \;
        end
        complete -c pj -f -a "(_pj)"
      '';

    custom.cache.home.directories = [".local/share/fish"];
  };
}
