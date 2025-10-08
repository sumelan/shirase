{
  config,
  pkgs,
  ...
}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      dysk # better disk info
      ets # add timestamp to beginning of each line
      fd # better find
      fx # terminal json viewer and processor
      htop
      jq
      just
      sd # better sed
      ugrep # grep, with boolean query patterns, e.g. ug --files -e "A" --and "B"
      ;
  };

  programs = {
    bat = {
      enable = true;
      extraPackages = [
        (pkgs.symlinkJoin {
          name = "batman";
          paths = [pkgs.bat-extras.batman];
          postBuild =
            #bash
            ''
              mkdir -p $out/share/bash-completion/completions
              echo 'complete -F _comp_cmd_man batman' > $out/share/bash-completion/completions/batman

              mkdir -p $out/share/fish/vendor_completions.d
              echo 'complete batman --wraps man' > $out/share/fish/vendor_completions.d/batman.fish

              mkdir -p $out/share/zsh/site-functions
              cat << EOF > $out/share/zsh/site-functions/_batman
              #compdef batman
              _man "$@"
              EOF
            '';
          meta.mainProgram = "batman";
        })
      ];
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    niri.settings.binds = {
      "Mod+Return" = {
        action.spawn = ["sh" "-c" "uwsm app -- foot"];
        hotkey-overlay.title = ''<span foreground="${config.lib.stylix.colors.withHashtag.base0B}">[Application]</span> Foot'';
      };
    };
  };
  custom.persist = {
    home = {
      cache.directories = [".local/share/zoxide"];
    };
  };
}
