{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkForce;
in {
  # fish plugins, home-manager's programs.fish.plugins has a weird format
  home.packages = builtins.attrValues {
    # do not add failed commands to history
    inherit (pkgs.fishPlugins) sponge;
  };

  programs = let
    fishPath = getExe config.programs.fish.package;
  in {
    fish = {
      enable = true;
      functions = {
        # use vi key bindings with hybrid emacs keybindings
        fish_user_key_bindings = ''
          fish_default_key_bindings -M insert
          fish_vi_key_bindings --no-erase insert
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

    # set as default interactive shell
    ghostty.settings = {
      command = mkForce "SHELL=${fishPath} ${fishPath}";
    };
    foot.settings = {
      main.shell = mkForce fishPath;
      environment = {
        "SHELL" = fishPath;
      };
    };
  };

  custom.persist = {
    home.cache.directories = [".local/share/fish"];
  };
}
