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

    palette = "catppuccin_frappe";

    palettes.catppuccin_frappe = {
      rosewater = "#f2d5cf";
      flamingo = "#eebebe";
      pink = "#f4b8e4";
      mauve = "#ca9ee6";
      red = "#e78284";
      maroon = "#ea999c";
      peach = "#ef9f76";
      yellow = "#e5c890";
      green = "#a6d189";
      teal = "#81c8be";
      sky = "#99d1db";
      sapphire = "#85c1dc";
      blue = "#8caaee";
      lavender = "#babbf1";
      text = "#c6d0f5";
      subtext1 = "#b5bfe2";
      subtext0 = "#a5adce";
      overlay2 = "#949cbb";
      overlay1 = "#838ba7";
      overlay0 = "#737994";
      surface2 = "#626880";
      surface1 = "#51576d";
      surface0 = "#414559";
      base = "#303446";
      mantle = "#292c3c";
      crust = "#232634";

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

      statusline1 = "#a7c080";
      statusline2 = "#d3c6aa";
      statusline3 = "#e67e80";
    };

    character = {
      format = "$symbol ";
      success_symbol = "[╰─](bold sapphire)[  ](bold blue)";
      error_symbol = "[╰─](bold sapphire)[  ](bold red)";
      vimcmd_symbol = "[╰─](bold sapphire)[  ](bold green)";
      vimcmd_visual_symbol = "[╰─](bold sapphire)[  ](bold mauve)";
      vimcmd_replace_symbol = "[╰─](bold sapphire])[  ](bold yellow)";
      vimcmd_replace_one_symbol = "[╰─](bold sapphire)[  ](bold yellow)";
    };
    container = {
      format = " [$symbol $name]($style) ";
      symbol = " ";
      style = "bold peach";
      disabled = false;
    };
    directory = {
      format = "[╭─ $path ]($style)";
      style = "bold sapphire";
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
      format = "[](fg:rosewater)[ $symbol $branch ]($style)[](fg:rosewater) ";
      style = "bg:rosewater fg:mantle";
      symbol = " ";
    };
    git_status = {
      disabled = false;
      style = "fg:red";
      format = "([$all_status$ahead_behind]($style))";
      up_to_date = "[  ](fg:mauve)";
      untracked = "[?\($count\)](fg:blue)";
      stashed = "[\\$\($count\)](fg:green_)";
      modified = "[!\($count\)](fg:yellow)";
      renamed = "[»\($count\)](fg:mauve)";
      deleted = "[✘\($count\)](fg:red)";
      staged = "[++\($count\)](fg:green)";
      ahead = "[⇡\($count\)](fg:blue)";
      diverged = "[⇕](fg:mauve)[⇡\($ahead_count\)](fg:green)[⇣\($behind_count\)](fg:yellow)";
      behind = "[⇣\($count\)](fg:red)";
    };
    cmd_duration = {
      disabled = false;
      format = " [](fg:teal)[  $duration ]($style)[](fg:teal)";
      style = "bg:teal fg:crust";
      min_time = 0;
      show_milliseconds = false;
    };
    username = {
      disabled = false;
      format = "[](fg:blue)[ $user ]($style)[](fg:blue) ";
      show_always = true;
      style_root = "bg:blue fg:red";
      style_user = "bg:blue fg:crust";
    };
    hostname = {
      # only show when conncted to to an SSH session
      ssh_only = true;
      ssh_symbol = "󰁥 ";
      format = "[](fg:green)[ $ssh_symbol$hostname ]($style)[](fg:green)";
      style = "bg:green fg:crust";
    };

    # Languages
    c = {
      style = "bg:sapphire fg:surface0";
      format = " [](fg:sapphire)[ $symbol$version ]($style)[](fg:sapphire)";
      disabled = false;
      symbol = " ";
    };
    elixir = {
      style = "bg:sapphire fg:surface0";
      format = " [](fg:sapphire)[ $symbol$version ]($style)[](fg:sapphire)";
      disabled = false;
      symbol = " ";
    };
    elm = {
      style = "bg:sapphire fg:surface0";
      format = " [](fg:sapphire)[ $symbol$version ]($style)[](fg:sapphire)";
      disabled = false;
      symbol = " ";
    };
    golang = {
      style = "bg:sapphire fg:surface0";
      format = " [](fg:sapphire)[ $symbol$version ]($style)[](fg:sapphire)";
      disabled = false;
      symbol = " ";
    };
    haskell = {
      style = "bg:sapphire fg:surface0";
      format = " [](fg:sapphire)[ $symbol$version ]($style)[](fg:sapphire)";
      disabled = false;
      symbol = " ";
    };
    java = {
      style = "bg:sapphire fg:surface0";
      format = " [](fg:sapphire)[ $symbol$version ]($style)[](fg:sapphire)";
      disabled = false;
      symbol = " ";
    };
    julia = {
      style = "bg:sapphire fg:surface0";
      format = " [](fg:sapphire)[ $symbol$version ]($style)[](fg:sapphire)";
      disabled = false;
      symbol = " ";
    };
    nodejs = {
      style = "bg:sapphire fg:surface0";
      format = " [](fg:sapphire)[ $symbol$version ]($style)[](fg:sapphire)";
      disabled = false;
      symbol = "󰎙 ";
    };
    nim = {
      style = "bg:sapphire fg:surface0";
      format = " [](fg:sapphire)[ $symbol$version ]($style)[](fg:sapphire)";
      disabled = false;
      symbol = "󰆥 ";
    };
    rust = {
      style = "bg:sapphire fg:surface0";
      format = " [](fg:sapphire)[ $symbol$version ]($style)[](fg:sapphire)";
      disabled = false;
      symbol = " ";
    };
    scala = {
      style = "bg:sapphire fg:surface0";
      format = " [](fg:sapphire)[ $symbol$version ]($style)[](fg:sapphire)";
      disabled = false;
      symbol = " ";
    };
    python = {
      style = "bg:sapphire fg:surface0";
      format = " [](fg:sapphire)[ $symbol$version ]($style)[](fg:sapphire)";
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
      style = "bg:sapphire fg:surface0";
      format = " [](fg:sapphire)[ $symbol$environment ]($style)[](fg:sapphire)";
      disabled = false;
      symbol = "🅒 ";
    };
  }
