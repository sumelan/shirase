_: {
  flake.modules.homeManager.default = {
    pkgs,
    user,
    ...
  }: {
    home = {
      shellAliases = {
        ":e" = "nvim";
        ":q" = "exit";
        ":wq" = "exit";
        c = "clear";
        cat = "bat";
        man = "batman";

        # cd aliases
        ".." = "cd ..";
        "..." = "cd ../..";

        z = "zoxide query -i";
      };

      packages = builtins.attrValues {
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
      eza = {
        enable = true;
        icons = "always";
        enableBashIntegration = true;
        enableFishIntegration = true;
        extraOptions = [
          "--group-directories-first"
          "--header"
          "--octal-permissions"
          "--hyperlink"
        ];
      };

      fzf = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
      };

      ripgrep = {
        enable = true;
        arguments = [
          "--smart-case"
          "--ignore-file=/home/${user}/.config/ripgrep/.ignore"
        ];
      };

      zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        options = ["--cmd cd"];
      };
    };

    xdg.configFile."ripgrep/.ignore".text = ''
      # global ignore file for ripgrep
      .envrc
      .ignore
      *.lock
      generated.nix
      generated.json
    '';

    custom.cache.home.directories = [".local/share/zoxide"];
  };
}
