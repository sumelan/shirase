{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.lib.monitors.mainMonitor.mode) width height;
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
in {
  imports = [
    ./shell.nix
  ];

  options.custom = {
    rofi.enable = mkEnableOption "Rofi";
  };

  config = mkIf config.custom.rofi.enable {
    programs = {
      rofi = {
        enable = true;
        font = "${config.custom.fonts.regular} 12";
        terminal = "foot";
        theme = "${config.xdg.configHome}/rofi/themes/launcher.rasi";
      };

      niri.settings = {
        spawn-at-startup = [
          {sh = "wl-paste --watch cliphist store &";}
        ];
        binds = {
          "Mod+Space" = {
            action.spawn = ["rofi" "-show" "drun"];
            hotkey-overlay.title = ''<span foreground="#B1C89D">[󰌧  Rofi]</span> Launcher'';
          };
          "Mod+V" = {
            action.spawn = ["clipboard-history"];
            hotkey-overlay.title = ''<span foreground="#B1C89D">[󰌧  Rofi]</span> Clipboard History'';
          };
        };
      };
    };

    xdg.configFile = {
      "rofi/themes/launcher.rasi".text =
        # rasi
        ''
          /*****----- Configuration -----*****/
          configuration {
          	modi:                       "drun,run,filebrowser,window";
              show-icons:                 true;
              display-drun:               "APPS";
              display-run:                "RUN";
              display-filebrowser:        "FILES";
              display-window:             "WINDOWS";
          	drun-display-format:        "{name}";
          	window-format:              "{w} · {c}";
          }

          /*****----- Global Properties -----*****/
          * {
              font:                        "${config.custom.fonts.monospace} 10";
              background:                  #D0D0D0;
              background-alt:              #E9E9E9;
              foreground:                  #161616;
              selected:                    #BEBEBE;
              active:                      #999999;
              urgent:                      #808080;
          }

          /*****----- Main Window -----*****/
          window {
              /* properties for window widget */
              transparency:                "real";
              location:                    center;
              anchor:                      center;
              fullscreen:                  false;
              width:                       1000px;
              x-offset:                    0px;
              y-offset:                    0px;

              /* properties for all widgets */
              enabled:                     true;
              border-radius:               15px;
              cursor:                      "default";
              background-color:            @background;
          }

          /*****----- Main Box -----*****/
          mainbox {
              enabled:                     true;
              spacing:                     0px;
              background-color:            transparent;
              orientation:                 vertical;
              children:                    [ "inputbar", "listbox" ];
          }

          listbox {
              spacing:                     20px;
              padding:                     20px;
              background-color:            transparent;
              orientation:                 vertical;
              children:                    [ "message", "listview" ];
          }

          /*****----- Inputbar -----*****/
          inputbar {
              enabled:                     true;
              spacing:                     10px;
              padding:                     100px 60px;
              background-color:            ${gray0}E6;
              text-color:                  @foreground;
              orientation:                 horizontal;
              children:                    [ "textbox-prompt-colon", "entry", "dummy", "mode-switcher" ];
          }
          textbox-prompt-colon {
              enabled:                     true;
              expand:                      false;
              str:                         "";
              padding:                     12px 15px;
              border-radius:               100%;
              background-color:            @background-alt;
              text-color:                  inherit;
          }
          entry {
              enabled:                     true;
              expand:                      false;
              width:                       300px;
              padding:                     12px 16px;
              border-radius:               100%;
              background-color:            @background-alt;
              text-color:                  inherit;
              cursor:                      text;
              placeholder:                 "Search";
              placeholder-color:           inherit;
          }
          dummy {
              expand:                      true;
              background-color:            transparent;
          }

          /*****----- Mode Switcher -----*****/
          mode-switcher{
              enabled:                     true;
              spacing:                     10px;
              background-color:            transparent;
              text-color:                  @foreground;
          }
          button {
              width:                       80px;
              padding:                     12px;
              border-radius:               100%;
              background-color:            @background-alt;
              text-color:                  inherit;
              cursor:                      pointer;
          }
          button selected {
              background-color:            @selected;
              text-color:                  @foreground;
          }

          /*****----- Listview -----*****/
          listview {
              enabled:                     true;
              columns:                     6;
              lines:                       3;
              cycle:                       true;
              dynamic:                     true;
              scrollbar:                   false;
              layout:                      vertical;
              reverse:                     false;
              fixed-height:                true;
              fixed-columns:               true;

              spacing:                     10px;
              background-color:            transparent;
              text-color:                  @foreground;
              cursor:                      "default";
          }

          /*****----- Elements -----*****/
          element {
              enabled:                     true;
              spacing:                     10px;
              padding:                     10px;
              border-radius:               15px;
              background-color:            transparent;
              text-color:                  @foreground;
              cursor:                      pointer;
              orientation:                 vertical;
          }
          element normal.normal {
              background-color:            inherit;
              text-color:                  inherit;
          }
          element normal.urgent {
              background-color:            @urgent;
              text-color:                  @foreground;
          }
          element normal.active {
              background-color:            @active;
              text-color:                  @foreground;
          }
          element selected.normal {
              background-color:            @selected;
              text-color:                  @foreground;
          }
          element selected.urgent {
              background-color:            @urgent;
              text-color:                  @foreground;
          }
          element selected.active {
              background-color:            @urgent;
              text-color:                  @foreground;
          }
          element-icon {
              background-color:            transparent;
              text-color:                  inherit;
              size:                        64px;
              cursor:                      inherit;
          }
          element-text {
              background-color:            transparent;
              text-color:                  inherit;
              cursor:                      inherit;
              vertical-align:              0.5;
              horizontal-align:            0.5;
          }

          /*****----- Message -----*****/
          message {
              background-color:            transparent;
          }
          textbox {
              padding:                     15px;
              border-radius:               15px;
              background-color:            @background-alt;
              text-color:                  @foreground;
              vertical-align:              0.5;
              horizontal-align:            0.0;
          }
          error-message {
              padding:                     15px;
              border-radius:               15px;
              background-color:            @background;
              text-color:                  @foreground;
          }
        '';

      "rofi/themes/cliphist.rasi".text =
        # rasi
        ''
          /*****----- Configuration -----*****/
          configuration {
              modi:                       "drun";
              show-icons:                 false;
              display-drun:               "󱉨 Clipboard";
              drun-display-format:        "{name}";
          }

          /*****----- Global Properties -----*****/
          * {
            background:           ${gray0}E6;
            background-alt:       ${gray2}E6;
            foreground:           ${white3}FF;
            selected:             ${cyan_base}E6;
            active:               ${blue0}FF;
            urgent:               ${yellow_base}FF;

            border-colour:               var(selected);
            handle-colour:               var(selected);
            background-colour:           var(background);
            foreground-colour:           var(foreground);
            alternate-background:        var(background-alt);
            normal-background:           var(background);
            normal-foreground:           var(foreground);
            urgent-background:           var(urgent);
            urgent-foreground:           var(background);
            active-background:           var(active);
            active-foreground:           var(background);
            selected-normal-background:  var(selected);
            selected-normal-foreground:  var(background);
            selected-urgent-background:  var(active);
            selected-urgent-foreground:  var(background);
            selected-active-background:  var(urgent);
            selected-active-foreground:  var(background);
            alternate-normal-background: var(background);
            alternate-normal-foreground: var(foreground);
            alternate-urgent-background: var(urgent);
            alternate-urgent-foreground: var(background);
            alternate-active-background: var(active);
            alternate-active-foreground: var(background);
          }

          /*****----- Main Window -----*****/
          window {
              /* properties for window widget */
              transparency:                "real";
              location:                    center;
              anchor:                      center;
              fullscreen:                  false;
              width:                       800px;
              x-offset:                    0px;
              y-offset:                    0px;

              /* properties for all widgets */
              enabled:                     true;
              margin:                      0px;
              padding:                     0px;
              border:                      0px solid;
              border-radius:               12px;
              border-color:                @border-colour;
              cursor:                      "default";
              background-color:            @background;
          }

          /*****----- Main Box -----*****/
          mainbox {
              enabled:                     true;
              spacing:                     10px;
              margin:                      0px;
              padding:                     40px;
              border:                      0px solid;
              border-radius:               0px 0px 0px 0px;
              border-color:                @border-colour;
              background-color:            transparent;
              children:                    [ "inputbar", "message", "listview" ];
          }

          /*****----- Inputbar -----*****/
          inputbar {
              enabled:                     true;
              spacing:                     10px;
              margin:                      0px;
              padding:                     0px;
              border:                      0px solid;
              border-radius:               0px;
              border-color:                @border-colour;
              background-color:            transparent;
              text-color:                  @foreground-colour;
              children:                    [ "prompt", "entry"];
          }
          prompt {
              enabled:                     true;
              background-color:            inherit;
              text-color:                  inherit;
          }
          entry {
              enabled:                     true;
              background-color:            inherit;
              text-color:                  inherit;
              cursor:                      text;
              placeholder:                 "Search...";
              placeholder-color:           inherit;
          }
          num-filtered-rows {
              enabled:                     true;
              expand:                      false;
              background-color:            inherit;
              text-color:                  inherit;
          }
          textbox-num-sep {
              enabled:                     true;
              expand:                      false;
              str:                         "/";
              background-color:            inherit;
              text-color:                  inherit;
          }
          num-rows {
              enabled:                     true;
              expand:                      false;
              background-color:            inherit;
              text-color:                  inherit;
          }
          case-indicator {
              enabled:                     true;
              background-color:            inherit;
              text-color:                  inherit;
          }

          /*****----- Listview -----*****/
          listview {
              enabled:                     true;
              columns:                     1;
              lines:                       12;
              cycle:                       true;
              dynamic:                     true;
              scrollbar:                   true;
              layout:                      vertical;
              reverse:                     false;
              fixed-height:                true;
              fixed-columns:               true;

              spacing:                     5px;
              margin:                      0px;
              padding:                     0px;
              border:                      0px solid;
              border-radius:               0px;
              border-color:                @border-colour;
              background-color:            transparent;
              text-color:                  @foreground-colour;
              cursor:                      "default";
          }
          scrollbar {
              handle-width:                5px ;
              handle-color:                @handle-colour;
              border-radius:               8px;
              background-color:            @alternate-background;
          }

          /*****----- Elements -----*****/
          element {
              enabled:                     true;
              spacing:                     8px;
              margin:                      0px;
              padding:                     8px;
              border:                      0px solid;
              border-radius:               4px;
              border-color:                @border-colour;
              background-color:            transparent;
              text-color:                  @foreground-colour;
              cursor:                      pointer;
          }
          element normal.normal {
              background-color:            var(normal-background);
              text-color:                  var(normal-foreground);
          }
          element normal.urgent {
              background-color:            var(urgent-background);
              text-color:                  var(urgent-foreground);
          }
          element normal.active {
              background-color:            var(active-background);
              text-color:                  var(active-foreground);
          }
          element selected.normal {
              background-color:            var(normal-foreground);
              text-color:                  var(normal-background);
          }
          element selected.urgent {
              background-color:            var(selected-urgent-background);
              text-color:                  var(selected-urgent-foreground);
          }
          element selected.active {
              background-color:            var(selected-active-background);
              text-color:                  var(selected-active-foreground);
          }
          element alternate.normal {
              background-color:            var(alternate-normal-background);
              text-color:                  var(alternate-normal-foreground);
          }
          element alternate.urgent {
              background-color:            var(alternate-urgent-background);
              text-color:                  var(alternate-urgent-foreground);
          }
          element alternate.active {
              background-color:            var(alternate-active-background);
              text-color:                  var(alternate-active-foreground);
          }
          element-icon {
              background-color:            transparent;
              text-color:                  inherit;
              size:                        24px;
              cursor:                      inherit;
          }
          element-text {
              background-color:            transparent;
              text-color:                  inherit;
              highlight:                   inherit;
              cursor:                      inherit;
              vertical-align:              0.5;
              horizontal-align:            0.0;
          }

          /*****----- Message -----*****/
          message {
              enabled:                     true;
              margin:                      0px;
              padding:                     0px;
              border:                      0px solid;
              border-radius:               0px 0px 0px 0px;
              border-color:                @border-colour;
              background-color:            transparent;
              text-color:                  @foreground-colour;
          }
          textbox {
              padding:                     8px;
              border:                      0px solid;
              border-radius:               4px;
              border-color:                @border-colour;
              background-color:            @alternate-background;
              text-color:                  @foreground-colour;
              vertical-align:              0.5;
              horizontal-align:            0.0;
              highlight:                   none;
              placeholder-color:           @foreground-colour;
              blink:                       true;
              markup:                      true;
          }
          error-message {
              padding:                     10px;
              border:                      0px solid;
              border-radius:               4px;
              border-color:                @border-colour;
              background-color:            @background-colour;
              text-color:                  @foreground-colour;
          }
        '';
    };
  };
}
