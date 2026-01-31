{lib, ...}: let
  inherit (lib) concatStrings mkAfter;
in {
  flake.modules.homeManager.default = {
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

          palette = "nord";

          palettes.nord = {
            # Black
            black0 = "#191D24";
            black1 = "#1E222A";
            black2 = "#222630";

            # Gray
            gray0 = "#242933";
            # Polar night
            gray1 = "#2E3440";
            gray2 = "#3B4252";
            gray3 = "#434C5E";
            gray4 = "#4C566A";
            # a light blue/gray
            # from @nightfox.nvim
            gray5 = "#60728A";

            # White
            # reduce_blue variant
            white0 = "#C0C8D8";
            # Snow storm
            white1 = "#D8DEE9";
            white2 = "#E5E9F0";
            white3 = "#ECEFF4";

            # Blue
            # Frost
            blue0 = "#5E81AC";
            blue1 = "#81A1C1";
            blue2 = "#88C0D0";

            # Cyan:
            cyan_base = "#8FBCBB";
            cyan_bright = "#9FC6C5";
            cyan_dim = "#80B3B2";

            # Aurora (from Nord theme)
            # Red
            red_base = "#BF616A";
            red_bright = "#C5727A";
            red_dim = "#B74E58";

            # Orange
            orange_base = "#D08770";
            orange_bright = "#D79784";
            orange_dim = "#CB775D";

            # Yellow
            yellow_base = "#EBCB8B";
            yellow_bright = "#EFD49F";
            yellow_dim = "#E7C173";

            # Green
            green_base = "#A3BE8C";
            green_bright = "#B1C89D";
            green_dim = "#97B67C";

            # Magenta
            magenta_base = "#B48EAD";
            magenta_bright = "#BE9DB8";
            magenta_dim = "#A97EA1";
          };

          character = {
            format = "$symbol ";
            success_symbol = "[╰─](bold white1)[  ](bold blue0)";
            error_symbol = "[╰─](bold white1)[  ](bold red_base)";
            vimcmd_symbol = "[╰─](bold white1)[  ](bold green_base)";
            vimcmd_visual_symbol = "[╰─](bold white1)[  ](bold magenta_base)";
            vimcmd_replace_symbol = "[╰─](bold white1)[  ](bold yellow_base)";
            vimcmd_replace_one_symbol = "[╰─](bold white1)[  ](bold yellow_base)";
          };
          container = {
            format = " [$symbol $name]($style) ";
            symbol = " ";
            style = "bold orange_bright";
            disabled = false;
          };
          directory = {
            format = "[╭─ $path ]($style)";
            style = "bold white1";
            truncation_length = 18;
            truncation_symbol = "…/";
            substitutions = {
              Documents = "󰈙";
              Pictures = " ";
            };
          };
          fill = {
            symbol = " ";
          };
          git_branch = {
            format = "[](fg:gray3)[ $symbol $branch ]($style)[](fg:gray3) ";
            style = "bg:gray3 fg:orange_bright";
            symbol = " ";
          };
          git_status = {
            disabled = false;
            style = "fg:red_dim";
            format = "([$all_status$ahead_behind]($style))";
            up_to_date = "[  ](fg:magenta_dim)";
            untracked = "[?\($count\)](fg:blue2)";
            stashed = "[\\$\($count\)](fg:green_bright)";
            modified = "[!\($count\)](fg:yellow_dim)";
            renamed = "[»\($count\)](fg:# magenta_bright)";
            deleted = "[✘\($count\)](fg:red_bright)";
            staged = "[++\($count\)](fg:green_dim)";
            ahead = "[⇡\($count\)](fg:blue1)";
            diverged = "[⇕](fg:magenta_dim)[⇡\($ahead_count\)](fg:green_dim)[⇣\($behind_count\)](fg:yellow_dim)";
            behind = "[⇣\($count\)](fg:red_bright)";
          };
          cmd_duration = {
            disabled = false;
            format = " [](fg:gray1)[  $duration ]($style)[](fg:gray1)";
            style = "bg:gray1 fg:magenta_base";
            min_time = 0;
            show_milliseconds = false;
          };
          username = {
            disabled = false;
            format = "[](fg:blue2)[ $user ]($style)[](fg:blue2) ";
            show_always = true;
            style_root = "bg:blue2 fg:red_bright";
            style_user = "bg:blue2 fg:black0";
          };
          hostname = {
            # only show when conncted to to an SSH session
            ssh_only = true;
            ssh_symbol = "󰁥 ";
            format = "[](fg:green_dim)[ $ssh_symbol$hostname ]($style)[](fg:green_dim) ";
            style = "bg:green_dim fg:white3";
          };

          # Languages
          c = {
            style = "bg:cyan_dim fg:orange_base";
            format = " [](fg:cyan_dim)[ $symbol$version ]($style)[](fg:cyan_dim)";
            disabled = false;
            symbol = " ";
          };
          elixir = {
            style = "bg:cyan_dim fg:orange_base";
            format = " [](fg:cyan_dim)[ $symbol$version ]($style)[](fg:cyan_dim)";
            disabled = false;
            symbol = " ";
          };
          elm = {
            style = "bg:cyan_dim fg:orange_base";
            format = " [](fg:cyan_dim)[ $symbol$version ]($style)[](fg:cyan_dim)";
            disabled = false;
            symbol = " ";
          };
          golang = {
            style = "bg:cyan_dim fg:orange_base";
            format = " [](fg:cyan_dim)[ $symbol$version ]($style)[](fg:cyan_dim)";
            disabled = false;
            symbol = " ";
          };
          haskell = {
            style = "bg:cyan_dim fg:orange_base";
            format = " [](fg:cyan_dim)[ $symbol$version ]($style)[](fg:cyan_dim)";
            disabled = false;
            symbol = " ";
          };
          java = {
            style = "bg:cyan_dim fg:orange_base";
            format = " [](fg:cyan_dim)[ $symbol$version ]($style)[](fg:cyan_dim)";
            disabled = false;
            symbol = " ";
          };
          julia = {
            style = "bg:cyan_dim fg:orange_base";
            format = " [](fg:cyan_dim)[ $symbol$version ]($style)[](fg:cyan_dim)";
            disabled = false;
            symbol = " ";
          };
          nodejs = {
            style = "bg:cyan_dim fg:orange_base";
            format = " [](fg:cyan_dim)[ $symbol$version ]($style)[](fg:cyan_dim)";
            disabled = false;
            symbol = "󰎙 ";
          };
          nim = {
            style = "bg:cyan_dim fg:orange_base";
            format = " [](fg:cyan_dim)[ $symbol$version ]($style)[](fg:cyan_dim)";
            disabled = false;
            symbol = "󰆥 ";
          };
          rust = {
            style = "bg:cyan_dim fg:orange_base";
            format = " [](fg:cyan_dim)[ $symbol$version ]($style)[](fg:cyan_base)";
            disabled = false;
            symbol = " ";
          };
          scala = {
            style = "bg:cyan_dim fg:orange_base";
            format = " [](fg:cyan_dim)[ $symbol$version ]($style)[](fg:cyan_dim)";
            disabled = false;
            symbol = " ";
          };
          python = {
            style = "bg:cyan_dim fg:orange_base";
            format = " [](fg:cyan_dim)[ $symbol$version ]($style)[](fg:cyan_dim)";
            disabled = false;
            symbol = " ";
          };
          nix_shell = {
            format = "via [$symbol$state( \($name\))]($style) ";
            symbol = "󱄅 ";
            style = "bold blue0";
            impure_msg = "impure";
            pure_msg = "pure";
            unknown_msg = "";
            disabled = false;
            heuristic = false;
          };
          conda = {
            style = "bg:cyan_dim fg:orange_base";
            format = " [](fg:cyan_dim)[ $symbol$environment ]($style)[](fg:cyan_dim)";
            disabled = false;
            symbol = "🅒 ";
          };
        };
      };

      fish = {
        # fix starship prompt to only have newlines after the first command
        # https://github.com/starship/starship/issues/560#issuecomment-1465630645
        shellInit =
          # fish
          ''
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
  };
}
