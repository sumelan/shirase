{
  pkgs,
  extraConfig ? {},
  nf-icon ? "",
}: let
  tomlFormat = pkgs.formats.toml {};

  format = pkgs.lib.concatStringsSep "" [
    # begin left format
    "$directory"
    "$git_branch"
    "$git_status"
    # end left format

    "$fill"

    # begin right format
    "$container"
    "$nix_shell"
    "$hostname"
    "$cmd_duration"
    # end right format

    "\n" # newline
    # begin left format
    "$character "
  ];

  baseConfig = {
    inherit format;

    add_newline = true;
    palette = "catppuccin-frappe";

    palettes.catppuccin-frappe = {
      crust = "#232634";
      mantle = "#292c3c";
      base = "#303446";

      surface0 = "#414559";
      surface1 = "#51576d";
      surface2 = "#626880";
      overlay0 = "#737994";
      overlay1 = "#949cbb";
      subtext0 = "#a5adce";
      subtext1 = "#b5bfe2";
      text = "#c6d0f5";

      lavender = "#babbf1";
      blue = "#8caaee";
      sapphire = "#85c1dc";
      sky = "#99d1db";
      teal = "#81c8be";

      green = "#a6d189";
      yellow = "#e5c890";
      peach = "#ef9f76";
      maroon = "#ea999c";
      red = "#e78284";
      mauve = "#ca9ee6";
      pink = "#f4b8e4";
      flamingo = "#eebebe";
      rosewater = "#f2d5cf";
    };

    character = {
      format = "$symbol";
      success_symbol = "[╰─](bold text)[  ${nf-icon}](bold blue)";
      error_symbol = "[╰─](bold text)[  ${nf-icon}](bold red)";
      vimcmd_symbol = "[╰─](bold text)[  ${nf-icon}](bold green_)";
      vimcmd_visual_symbol = "[╰─](bold white1)[  ${nf-icon}](bold mauve)";
      vimcmd_replace_symbol = "[╰─](bold white1])[  ${nf-icon}](bold yellow)";
      vimcmd_replace_one_symbol = "[╰─](bold white1)[  ${nf-icon}](bold yellow)";
    };
    container = {
      format = " [$symbol $name]($style) ";
      symbol = " ";
      style = "bold maroon";
      disabled = false;
    };
    directory = {
      format = "[╭─ $path ]($style)";
      style = "bold lavender";
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
      format = "[](fg:teal)[ $symbol $branch ]($style)[](fg:teal) ";
      style = "bg:teal fg:base";
      symbol = " ";
    };
    git_status = {
      disabled = false;
      style = "fg:red";
      format = "([$all_status$ahead_behind]($style))";
      up_to_date = "[  ](fg:mauve)";
      untracked = ''[?($count)](fg:blue)'';
      stashed = ''[\$($count)](fg:green)'';
      modified = ''[!($count)](fg:yellow)'';
      renamed = ''[»($count)](fg:mauve)'';
      deleted = ''[✘($count)](fg:red)'';
      staged = ''[++($count)](fg:green)'';
      ahead = ''[⇡($count)](fg:blue)'';
      diverged = ''[⇕](fg:mauve)[⇡($ahead_count)](fg:green)[⇣($behind_count)](fg:yellow)'';
      behind = ''[⇣($count)](fg:red)'';
    };
    cmd_duration = {
      disabled = false;
      format = "[](fg:overlay0)[  $duration ]($style)[](fg:overlay0)";
      style = "bg:surface1 fg:mauve";
      min_time = 0;
      show_milliseconds = false;
    };
    hostname = {
      # only show when conncted to to an SSH session
      ssh_only = true;
      ssh_symbol = "󰁥 ";
      format = "[](fg:green)[ $ssh_symbol$hostname ]($style)[](fg:green) ";
      style = "bg:green fg:base";
    };

    # Languages
    nix_shell = {
      format = ''via [$symbol$state(($name))]($style)'';
      symbol = "󱄅 ";
      style = "bold blue";
      impure_msg = "impure";
      pure_msg = "pure";
      unknown_msg = "";
      disabled = false;
      heuristic = false;
    };
  };
in
  tomlFormat.generate "starship.toml" (pkgs.lib.recursiveUpdate baseConfig extraConfig)
