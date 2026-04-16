{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) concatStrings;
  tomlFmt = pkgs.formats.toml {};
in
  tomlFmt.generate "starship.toml" {
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
      bg_dim = "#232a2e";
      bg0 = "#2d353b";
      bg1 = "#343f44";
      bg2 = "#3d484d";
      bg3 = "#475258";
      bg4 = "#4f585e";
      bg5 = "#56635f";
      bg_visual = "#543a48";
      bg_red = "#514045";
      bg_green = "#425047";
      bg_blue = "#3a515d";
      bg_yellow = "#4d4c43";

      fg = "#d3c6aa";
      red = "#e67e80";

      orange = "#e69875";
      yellow = "#dbbc7f";
      green = "#a7c080";
      aqua = "#83c092";
      blue = "#7fbbb3";
      purple = "#d699b6";
      grey0 = "#7a8478";
      grey1 = "#859289";
      grey2 = "#9da9a0";
      statusline1 = "#a7c080";
      statusline2 = "#d3c6aa";
      statusline3 = "#e67e80";
    };

    character = {
      format = "$symbol ";
      success_symbol = "[╰─](bold aqua)[  ](bold blue)";
      error_symbol = "[╰─](bold aqua)[  ](bold red)";
      vimcmd_symbol = "[╰─](bold aqua)[  ](bold green)";
      vimcmd_visual_symbol = "[╰─](bold aqua)[  ](bold purple)";
      vimcmd_replace_symbol = "[╰─](bold aqua])[  ](bold yellow)";
      vimcmd_replace_one_symbol = "[╰─](bold aqua)[  ](bold yellow)";
    };
    container = {
      format = " [$symbol $name]($style) ";
      symbol = " ";
      style = "bold orange";
      disabled = false;
    };
    directory = {
      format = "[╭─ $path ]($style)";
      style = "bold aqua";
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
      format = "[](fg:statusline2)[ $symbol $branch ]($style)[](fg:statusline2) ";
      style = "bg:statusline2 fg:bg_dim";
      symbol = " ";
    };
    git_status = {
      disabled = false;
      style = "fg:red";
      format = "([$all_status$ahead_behind]($style))";
      up_to_date = "[  ](fg:purple)";
      untracked = "[?\($count\)](fg:blue)";
      stashed = "[\\$\($count\)](fg:green_)";
      modified = "[!\($count\)](fg:yellow)";
      renamed = "[»\($count\)](fg:purple)";
      deleted = "[✘\($count\)](fg:red)";
      staged = "[++\($count\)](fg:green)";
      ahead = "[⇡\($count\)](fg:blue)";
      diverged = "[⇕](fg:purple)[⇡\($ahead_count\)](fg:green)[⇣\($behind_count\)](fg:yellow)";
      behind = "[⇣\($count\)](fg:red)";
    };
    cmd_duration = {
      disabled = false;
      format = " [](fg:statusline1)[  $duration ]($style)[](fg:statusline1)";
      style = "bg:statusline1 fg:bg_visual";
      min_time = 0;
      show_milliseconds = false;
    };
    username = {
      disabled = false;
      format = "[](fg:blue)[ $user ]($style)[](fg:blue) ";
      show_always = true;
      style_root = "bg:blue fg:red";
      style_user = "bg:blue fg:bg_dim";
    };
    hostname = {
      # only show when conncted to to an SSH session
      ssh_only = true;
      ssh_symbol = "󰁥 ";
      format = "[](fg:green)[ $ssh_symbol$hostname ]($style)[](fg:green)";
      style = "bg:green fg:statusline2";
    };

    # Languages
    c = {
      style = "bg:aqua fg:grey0";
      format = " [](fg:aqua)[ $symbol$version ]($style)[](fg:aqua)";
      disabled = false;
      symbol = " ";
    };
    elixir = {
      style = "bg:aqua fg:grey0";
      format = " [](fg:aqua)[ $symbol$version ]($style)[](fg:aqua)";
      disabled = false;
      symbol = " ";
    };
    elm = {
      style = "bg:aqua fg:grey0";
      format = " [](fg:aqua)[ $symbol$version ]($style)[](fg:aqua)";
      disabled = false;
      symbol = " ";
    };
    golang = {
      style = "bg:aqua fg:grey0";
      format = " [](fg:aqua)[ $symbol$version ]($style)[](fg:aqua)";
      disabled = false;
      symbol = " ";
    };
    haskell = {
      style = "bg:aqua fg:grey0";
      format = " [](fg:aqua)[ $symbol$version ]($style)[](fg:aqua)";
      disabled = false;
      symbol = " ";
    };
    java = {
      style = "bg:aqua fg:grey0";
      format = " [](fg:aqua)[ $symbol$version ]($style)[](fg:aqua)";
      disabled = false;
      symbol = " ";
    };
    julia = {
      style = "bg:aqua fg:grey0";
      format = " [](fg:aqua)[ $symbol$version ]($style)[](fg:aqua)";
      disabled = false;
      symbol = " ";
    };
    nodejs = {
      style = "bg:aqua fg:grey0";
      format = " [](fg:aqua)[ $symbol$version ]($style)[](fg:aqua)";
      disabled = false;
      symbol = "󰎙 ";
    };
    nim = {
      style = "bg:aqua fg:grey0";
      format = " [](fg:aqua)[ $symbol$version ]($style)[](fg:aqua)";
      disabled = false;
      symbol = "󰆥 ";
    };
    rust = {
      style = "bg:aqua fg:grey0";
      format = " [](fg:aqua)[ $symbol$version ]($style)[](fg:aqua)";
      disabled = false;
      symbol = " ";
    };
    scala = {
      style = "bg:aqua fg:grey0";
      format = " [](fg:aqua)[ $symbol$version ]($style)[](fg:aqua)";
      disabled = false;
      symbol = " ";
    };
    python = {
      style = "bg:aqua fg:grey0";
      format = " [](fg:aqua)[ $symbol$version ]($style)[](fg:aqua)";
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
      style = "bg:aqua fg:grey0";
      format = " [](fg:aqua)[ $symbol$environment ]($style)[](fg:aqua)";
      disabled = false;
      symbol = "🅒 ";
    };
  }
