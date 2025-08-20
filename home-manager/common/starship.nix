{
  lib,
  config,
  ...
}: {
  programs = {
    starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableTransience = true;
      settings = with config.lib.stylix.colors.withHashtag; {
        add_newline = false;
        format = lib.concatStrings [
          # begin left format
          "$directory"
          "$git_branch"
          "$git_status"
          # end left format
          "$fill"
          # begin right format
          "$c"
          "$elixir"
          "$elm"
          "$golang"
          "$haskell"
          "$java"
          "$julia"
          "$nodejs"
          "$nim"
          "$rust"
          "$scala"
          "$conda"
          "$python"
          "$container"
          "$nix_shell"
          "$time"
          # end right format
          "\n" # newline
          # begin left format
          "$character "
          "$username"
        ];

        palette = "rose-pine";
        palettes.rose-pine = {
          overlay = base01;
          love = base08;
          gold = base0A;
          rose = base07;
          pine = base0D;
          foam = base0B;
          iris = base0E;
        };

        character = {
          format = "$symbol ";
          success_symbol = "[╰─](bold iris)[ ](bold iris)";
          error_symbol = "[╰─](bold iris)[ ](bold love)";
          vimcmd_symbol = "[╰─](bold iris)[ ](bold foam)";
          vimcmd_visual_symbol = "[╰─](bold iris)[ ](bold pine)";
          vimcmd_replace_symbol = "[╰─](bold iris)[ ](bold gold)";
          vimcmd_replace_one_symbol = "[╰─](bold iris)[ ](bold gold)";
        };
        container = {
          format = " [$symbol $name]($style) ";
          symbol = " ";
          style = "love bold";
          disabled = false;
        };
        directory = {
          format = "[╭─ $path ]($style)";
          style = "bold iris";
          truncation_length = 3;
          truncation_symbol = "…/";
          substitutions = {
            Documents = "󰈙";
            Pictures = " ";
          };
        };
        fill = {
          style = "fg:overlay";
          symbol = " ";
        };
        git_branch = {
          format = "[](fg:overlay)[ $symbol $branch ]($style)[](fg:overlay) ";
          style = "bg:overlay fg:foam";
          symbol = " ";
        };
        git_status = {
          disabled = false;
          style = "fg:love";
          format = "([$all_status$ahead_behind]($style))";
          up_to_date = "[ 󰋑 ](fg:iris)";
          untracked = "[?\($count\)](fg:gold)";
          stashed = "[\\$\($count\)](fg:iris)";
          modified = "[!\($count\)](fg:gold)";
          renamed = "[»\($count\)](fg:iris)";
          deleted = "[✘\($count\)](style)";
          staged = "[++\($count\)](fg:gold)";
          ahead = "[⇡\($count\)](fg:foam)";
          diverged = "[⇕\[](fg:iris)[⇡\($ahead_count\)](fg:foam)[⇣\($behind_count\)](fg:rose)[\]](fg:iris)";
          behind = "[⇣\($count\)](fg:rose)";
        };
        time = {
          disabled = false;
          format = " [](fg:overlay)[ $time 󰧱 ]($style)[](fg:overlay)";
          style = "bg:overlay fg:purple";
          time_format = "%H:%M";
          use_12hr = false;
        };
        username = {
          disabled = false;
          format = "[](fg:overlay)[ 󰧱 $user ]($style)[](fg:overlay) ";
          show_always = true;
          style_root = "bg:overlay fg:iris";
          style_user = "bg:overlay fg:iris";
        };

        # Languages

        c = {
          style = "bg:overlay fg:pine";
          format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
          disabled = false;
          symbol = " ";
        };
        elixir = {
          style = "bg:overlay fg:pine";
          format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
          disabled = false;
          symbol = " ";
        };
        elm = {
          style = "bg:overlay fg:pine";
          format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
          disabled = false;
          symbol = " ";
        };
        golang = {
          style = "bg:overlay fg:pine";
          format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
          disabled = false;
          symbol = " ";
        };
        haskell = {
          style = "bg:overlay fg:pine";
          format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
          disabled = false;
          symbol = " ";
        };
        java = {
          style = "bg:overlay fg:pine";
          format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
          disabled = false;
          symbol = " ";
        };
        julia = {
          style = "bg:overlay fg:pine";
          format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
          disabled = false;
          symbol = " ";
        };
        nodejs = {
          style = "bg:overlay fg:pine";
          format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
          disabled = false;
          symbol = "󰎙 ";
        };
        nim = {
          style = "bg:overlay fg:pine";
          format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
          disabled = false;
          symbol = "󰆥 ";
        };
        rust = {
          style = "bg:overlay fg:pine";
          format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
          disabled = false;
          symbol = " ";
        };
        scala = {
          style = "bg:overlay fg:pine";
          format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
          disabled = false;
          symbol = " ";
        };
        python = {
          style = "bg:overlay fg:pine";
          format = " [](fg:overlay)[ $symbol$version ]($style)[](fg:overlay)";
          disabled = false;
          symbol = " ";
        };
        nix_shell = {
          format = "via [$symbol$state( \($name\))]($style) ";
          symbol = "󱄅 ";
          style = "bold foam";
          impure_msg = "impure";
          pure_msg = "pure";
          unknown_msg = "";
          disabled = false;
          heuristic = false;
        };
        conda = {
          style = "bg:overlay fg:pine";
          format = " [](fg:overlay)[ $symbol$environment ]($style)[](fg:overlay)";
          disabled = false;
          symbol = "🅒 ";
        };
      };
    };

    fish = {
      # fix starship prompt to only have newlines after the first command
      # https://github.com/starship/starship/issues/560#issuecomment-1465630645
      shellInit = ''
        function prompt_newline --on-event fish_postexec
          echo ""
        end
      '';
      interactiveShellInit =
        lib.mkAfter
        # fish
        ''
          function starship_transient_prompt_func
            starship module character
          end
        '';
    };
    # some sort of race condition with kitty and starship
    # https://github.com/kovidgoyal/kitty/issues/4476#issuecomment-1013617251
    kitty.shellIntegration.enableBashIntegration = false;
  };
  stylix.targets.starship.enable = false;
}
