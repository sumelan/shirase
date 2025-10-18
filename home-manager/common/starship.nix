{lib, ...}: let
  inherit (lib) concatStrings mkAfter;

  base01 = "#212337";
  base08 = "#7081d0";
  base0A = "#04d1f9";
  base0B = "#37f499";
  base0C = "#f7c67f";
  base0D = "#f265b5";
  base0E = "#a48cf2";
in {
  programs = {
    starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableTransience = true;
      settings = {
        add_newline = false;
        format = concatStrings [
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
          "$cmd_duration"
          # end right format

          "\n" # newline

          # begin left format
          "$character "
          "$username"
          "$hostname"
        ];

        palette = "custom";
        palettes.custom = {
          overlay = base01;
          love = base08;
          gold = base0A;
          rose = base0C;
          pine = base0D;
          foam = base0B;
          iris = base0E;
        };

        character = {
          format = "$symbol ";
          success_symbol = "[╰─](bold iris)[  ](bold iris)";
          error_symbol = "[╰─](bold iris)[  ](bold love)";
          vimcmd_symbol = "[╰─](bold iris)[  ](bold foam)";
          vimcmd_visual_symbol = "[╰─](bold iris)[  ](bold pine)";
          vimcmd_replace_symbol = "[╰─](bold iris)[  ](bold gold)";
          vimcmd_replace_one_symbol = "[╰─](bold iris)[  ](bold gold)";
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
          truncation_length = 18;
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
          up_to_date = "[  ](fg:iris)";
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
        cmd_duration = {
          disabled = false;
          format = " [](fg:overlay)[  $duration ]($style)[](fg:overlay)";
          style = "bg:overlay fg:purple";
          min_time = 0;
          show_milliseconds = false;
        };
        username = {
          disabled = false;
          format = "[](fg:overlay)[ $user ]($style)[](fg:overlay) ";
          show_always = true;
          style_root = "bg:overlay fg:rose";
          style_user = "bg:overlay fg:rose";
        };
        hostname = {
          # only show when conncted to to an SSH session
          ssh_only = true;
          ssh_symbol = "󰁥 ";
          format = "[](fg:overlay)[ $ssh_symbol$hostname ]($style)[](fg:overlay) ";
          style = "bg:overlay fg:pine";
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
        mkAfter
        # fish
        ''
          function starship_transient_prompt_func
            starship module character
          end
        '';
    };
  };
}
