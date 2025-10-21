{lib, ...}: let
  inherit (lib) concatStrings mkAfter;
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

        palette = "everforest";

        palettes.everforest = {
          bg-dim = "#232A2E";
          bg0 = "#2D353B";
          bg1 = "#343F44";
          bg2 = "#3D484D";
          bg3 = "#475258";
          bg4 = "#4F585E";
          bg5 = "#56635f";
          bg-visual = "#543A48";
          bg-red = "#514045";
          bg-green = "#425047";
          bg-blue = "#3A515D";
          bg-yellow = "#4D4C43";
          fg = "#D3C6AA";
          red = "#E67E80";
          orange = "#E69875";
          yellow = "#DBBC7F";
          green = "#A7C080";
          aqua = "#83C092";
          blue = "#7FBBB3";
          purple = "#D699B6";
          grey0 = "#7A8478";
          grey1 = "#859289";
          grey2 = "#9DA9A0";
          statusline1 = "#A7C080";
          statusline2 = "#D3C6AA";
          statusline3 = "#E67E80";
        };

        character = {
          format = "$symbol ";
          success_symbol = "[╰─](bold statusline1)[  ](bold fg)";
          error_symbol = "[╰─](bold statusline1)[  ](bold red)";
          vimcmd_symbol = "[╰─](bold statusline1)[  ](bold green)";
          vimcmd_visual_symbol = "[╰─](bold statusline1)[  ](bold aqua)";
          vimcmd_replace_symbol = "[╰─](bold statusline1)[  ](bold yellow)";
          vimcmd_replace_one_symbol = "[╰─](bold statusline1)[  ](bold yellow)";
        };
        container = {
          format = " [$symbol $name]($style) ";
          symbol = " ";
          style = "orange bold";
          disabled = false;
        };
        directory = {
          format = "[╭─ $path ]($style)";
          style = "bold statusline1";
          truncation_length = 18;
          truncation_symbol = "…/";
          substitutions = {
            Documents = "󰈙";
            Pictures = " ";
          };
        };
        fill = {
          style = "fg:statusline2";
          symbol = " ";
        };
        git_branch = {
          format = "[](fg:bg-green)[ $symbol $branch ]($style)[](fg:bg-green) ";
          style = "bg:bg-green fg:fg";
          symbol = " ";
        };
        git_status = {
          disabled = false;
          style = "fg:bg-red";
          format = "([$all_status$ahead_behind]($style))";
          up_to_date = "[  ](fg:purple)";
          untracked = "[?\($count\)](fg:blue)";
          stashed = "[\\$\($count\)](fg:aqua)";
          modified = "[!\($count\)](fg:yellow)";
          renamed = "[»\($count\)](fg:purple)";
          deleted = "[✘\($count\)](fg:red)";
          staged = "[++\($count\)](fg:aqua)";
          ahead = "[⇡\($count\)](fg:blue)";
          diverged = "[⇕\[](fg:purple)[⇡\($ahead_count\)](fg:aqua)[⇣\($behind_count\)](fg:yellow)[\]](fg:purple)";
          behind = "[⇣\($count\)](fg:red)";
        };
        cmd_duration = {
          disabled = false;
          format = " [](fg:bg-visual)[  $duration ]($style)[](fg:bg-visual)";
          style = "bg:bg-visual fg:purple";
          min_time = 0;
          show_milliseconds = false;
        };
        username = {
          disabled = false;
          format = "[](fg:bg-visual)[ $user ]($style)[](fg:bg-visual) ";
          show_always = true;
          style_root = "bg:bg-visual fg:orange";
          style_user = "bg:bg-visual fg:red";
        };
        hostname = {
          # only show when conncted to to an SSH session
          ssh_only = true;
          ssh_symbol = "󰁥 ";
          format = "[](fg:bg-visual)[ $ssh_symbol$hostname ]($style)[](fg:bg-visual) ";
          style = "bg:bg-visual fg:orange";
        };

        # Languages
        c = {
          style = "bg:bg-visual fg:orange";
          format = " [](fg:bg-visual)[ $symbol$version ]($style)[](fg:bg-visual)";
          disabled = false;
          symbol = " ";
        };
        elixir = {
          style = "bg:bg-visual fg:orange";
          format = " [](fg:bg-visual)[ $symbol$version ]($style)[](fg:bg-visual)";
          disabled = false;
          symbol = " ";
        };
        elm = {
          style = "bg:bg-visual fg:orange";
          format = " [](fg:bg-visual)[ $symbol$version ]($style)[](fg:bg-visual)";
          disabled = false;
          symbol = " ";
        };
        golang = {
          style = "bg:bg-visual fg:orange";
          format = " [](fg:bg-visual)[ $symbol$version ]($style)[](fg:bg-visual)";
          disabled = false;
          symbol = " ";
        };
        haskell = {
          style = "bg:bg-visual fg:orange";
          format = " [](fg:bg-visual)[ $symbol$version ]($style)[](fg:bg-visual)";
          disabled = false;
          symbol = " ";
        };
        java = {
          style = "bg:bg-visual fg:orange";
          format = " [](fg:bg-visual)[ $symbol$version ]($style)[](fg:bg-visual)";
          disabled = false;
          symbol = " ";
        };
        julia = {
          style = "bg:bg-visual fg:orange";
          format = " [](fg:bg-visual)[ $symbol$version ]($style)[](fg:bg-visual)";
          disabled = false;
          symbol = " ";
        };
        nodejs = {
          style = "bg:bg-visual fg:orange";
          format = " [](fg:bg-visual)[ $symbol$version ]($style)[](fg:bg-visual)";
          disabled = false;
          symbol = "󰎙 ";
        };
        nim = {
          style = "bg:bg-visual fg:orange";
          format = " [](fg:bg-visual)[ $symbol$version ]($style)[](fg:bg-visual)";
          disabled = false;
          symbol = "󰆥 ";
        };
        rust = {
          style = "bg:bg-visual fg:orange";
          format = " [](fg:bg-visual)[ $symbol$version ]($style)[](fg:bg-visual)";
          disabled = false;
          symbol = " ";
        };
        scala = {
          style = "bg:bg-visual fg:orange";
          format = " [](fg:bg-visual)[ $symbol$version ]($style)[](fg:bg-visual)";
          disabled = false;
          symbol = " ";
        };
        python = {
          style = "bg:bg-visual fg:orange";
          format = " [](fg:bg-visual)[ $symbol$version ]($style)[](fg:bg-visual)";
          disabled = false;
          symbol = " ";
        };
        nix_shell = {
          format = "via [$symbol$state( \($name\))]($style) ";
          symbol = "󱄅 ";
          style = "bold blue";
          impure_msg = "impure";
          pure_msg = "pure";
          unknown_msg = "";
          disabled = false;
          heuristic = false;
        };
        conda = {
          style = "bg:bg-visual fg:orange";
          format = " [](fg:bg-visual)[ $symbol$environment ]($style)[](fg:bg-visual)";
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
