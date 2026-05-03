{
  pkgs,
  extraConfig,
  extraBinds,
}: let
  configAttrs =
    {
      allow_remote_control = "yes";
      font_family = "Maple Mono NF";
      font_size = "14";
      bold_font = "auto";
      bold_italic_font = "auto";
      copy_on_select = "yes";
      cursor_blink_interval = "0.5";
      cursor_shape = "block";
      cursor_stop_blinking_after = "15.0";
      cursor_trail = "3";
      cursor_trail_start_threshold = "10";
      enable_audio_bell = "no";
      italic_font = "auto";
      placement_strategy = "top";
      scrollback_lines = "10000";
      strip_trailing_spaces = "smart";
      tab_bar_edge = "top";
      url_style = "single";
      visual_bell_duration = "0.1";
      window_padding_width = "3";
    }
    // extraConfig;
  bindAttrs =
    {}
    // extraBinds;
  configText = pkgs.lib.concatStringsSep "\n" (
    (pkgs.lib.mapAttrsToList (name: value: "${name} ${value}") configAttrs)
    ++ (pkgs.lib.mapAttrsToList (name: value: "map ${name} ${value}") bindAttrs)
  );
in
  pkgs.writeText "wrapped-kitty.conf" configText
