{
  lib,
  config,
  ...
}: let
  inherit
    (lib.custom.colors)
    gray0
    gray2
    gray3
    gray4
    gray5
    white0
    white3
    blue0
    green_dim
    cyan_base
    cyan_bright
    yellow_base
    orange_bright
    ;
in {
  imports = [
    ./shell.nix
  ];

  programs = {
    rofi = {
      enable = true;
      font = "${config.custom.fonts.monospace} 14";
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
          hotkey-overlay.title = ''<span foreground="#D79784">[ Rofi]</span> Launcher'';
        };
        "Mod+V" = {
          action.spawn = ["clipboard-history"];
          hotkey-overlay.title = ''<span foreground="#D79784">[ Rofi]</span> Clipboard History'';
        };
        "Mod+X" = {
          action.spawn = ["power-selecter"];
          hotkey-overlay.title = ''<span foreground="#D79784">[ Rofi]</span> Powerprofile'';
        };
        "Mod+Alt+Backslash" = {
          action.spawn = ["dynamiccast-selecter"];
          hotkey-overlay.title = ''<span foreground="#D79784">[ Rofi]</span> Dynamiccast'';
        };
      };
    };
  };

  xdg.configFile = {
    "rofi/themes/launcher.rasi".text =
      # rasi
      ''
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

        /* Global Properties */
        * {
            font:                        "${config.custom.fonts.monospace} 14";
            background:                  ${white3};
            background-alt:              ${white0};
            foreground:                  ${gray5};
            selected:                    ${orange_bright}E5;
            active:                      ${gray3};
            urgent:                      ${gray4};
        }

        /* Main Window */
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

        /* Main Box */
        mainbox {
            enabled:                     true;
            spacing:                     0px;
            background-color:            transparent;
            orientation:                 vertical;
            children:                    [ "inputbar", "mode-switcher", "listbox" ];
        }

        /** dummy **/
        dummy {
            expand:                      true;
            background-color:            transparent;
        }

        /* Inputbar */
        inputbar {
            enabled:                     true;
            spacing:                     10px;
            padding:                     30px 60px;
            background-color:            ${gray0}E6;
            text-color:                  @foreground;
            orientation:                 horizontal;
            children:                    [ "textbox-prompt-colon", "entry", "dummy" ];
        }
        textbox-prompt-colon {
            enabled:                     true;
            expand:                      false;
            str:                         " ";
            padding:                     12px 15px;
            border-radius:               100%;
            background-color:            @background;
            text-color:                  inherit;
        }
        entry {
            enabled:                     true;
            expand:                      false;
            width:                       300px;
            padding:                     10px 15px;
            border-radius:               100%;
            background-color:            @background;
            text-color:                  inherit;
            cursor:                      text;
            placeholder:                 "Search...";
            placeholder-color:           inherit;
        }

        /* Mode Switcher */
        mode-switcher{
            enabled:                     true;
            spacing:                     10px;
            padding:                     15px 15px;
            background-color:            ${green_dim}E6;
            text-color:                  @foreground;
        }
        button {
            width:                       30px;
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

        /* Listbox */
        listbox {
            spacing:                     20px;
            padding:                     20px;
            background-color:            transparent;
            orientation:                 vertical;
            children:                    [ "message", "listview" ];
        }

        /** Message **/
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

        /** Listview **/
        listview {
            enabled:                     true;
            columns:                     4;
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
        /*** Elements ***/
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
            background-color:            ${cyan_bright}E5;
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
      '';

    "rofi/themes/cliphist.rasi".text =
      # rasi
      ''
        configuration {
            modi:                       "drun";
            show-icons:                 false;
            display-drun:               "󱉨 Clipboard";
            drun-display-format:        "{name}";
        }

        /* Global Properties */
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

        /* Main Window */
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

        /* Main Box */
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

        /* Inputbar */
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

        /* Listview */
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

        /* Elements */
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

        /* Message */
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

    "rofi/themes/selecter.rasi".text =
      #rasi
      ''
        configuration {
            show-icons:                 false;
        }

        /* Global Properties */
        * {
            background:           ${gray0}E6;
            background-alt:       ${gray2}E6;
            foreground:           ${white3}FF;
            selected:             ${cyan_base}E6;
            active:               ${blue0}FF;
            urgent:               ${yellow_base}FF;
            font: "${config.custom.fonts.monospace} 14";
        }

        /* Main Window */
        window {
            /* properties for window widget */
            transparency:                "real";
            location:                    center;
            anchor:                      center;
            fullscreen:                  false;
            width:                       400px;
            x-offset:                    0px;
            y-offset:                    0px;

            /* properties for all widgets */
            enabled:                     true;
            margin:                      0px;
            padding:                     0px;
            border:                      0px solid;
            border-radius:               12px;
            border-color:                @selected;
            cursor:                      "default";
            background-color:            @background;
        }

        /* Main Box */
        mainbox {
            enabled:                     true;
            spacing:                     10px;
            margin:                      0px;
            padding:                     20px;
            border:                      0px solid;
            border-radius:               0px;
            border-color:                @selected;
            background-color:            transparent;
            children:                    [ "inputbar", "message", "listview" ];
        }

        /* Inputbar */
        inputbar {
            enabled:                     true;
            spacing:                     10px;
            margin:                      0px;
            padding:                     0px;
            border:                      0px;
            border-radius:               0px;
            border-color:                @selected;
            background-color:            transparent;
            text-color:                  @foreground;
            children:                    ["prompt"];
        }

        prompt {
            enabled:                     true;
            padding:                     10px;
            border-radius:               10px;
            background-color:            @active;
            text-color:                  @background;
        }

        /* Message */
        message {
            enabled:                     true;
            margin:                      0px;
            padding:                     10px;
            border:                      0px solid;
            border-radius:               10px;
            border-color:                @selected;
            background-color:            @background-alt;
            text-color:                  @foreground;
        }
        textbox {
            background-color:            inherit;
            text-color:                  inherit;
            vertical-align:              0.5;
            horizontal-align:            0.0;
            placeholder-color:           @foreground;
            blink:                       true;
            markup:                      true;
        }
        error-message {
            padding:                     10px;
            border:                      0px solid;
            border-radius:               0px;
            border-color:                @selected;
            background-color:            @background;
            text-color:                  @foreground;
        }

        /* Listview */
        listview {
            enabled:                     true;
            columns:                     1;
            lines:                       5;
            cycle:                       true;
            dynamic:                     true;
            scrollbar:                   false;
            layout:                      vertical;
            reverse:                     false;
            fixed-height:                true;
            fixed-columns:               true;

            spacing:                     5px;
            margin:                      0px;
            padding:                     0px;
            border:                      0px solid;
            border-radius:               0px;
            border-color:                @selected;
            background-color:            transparent;
            text-color:                  @foreground;
            cursor:                      "default";
        }

        /* Elements */
        element {
            enabled:                     true;
            spacing:                     0px;
            margin:                      0px;
            padding:                     10px;
            border:                      0px solid;
            border-radius:               10px;
            border-color:                @selected;
            background-color:            transparent;
            text-color:                  @foreground;
            cursor:                      pointer;
        }
        element-text {
            background-color:            transparent;
            text-color:                  inherit;
            cursor:                      inherit;
            vertical-align:              0.5;
            horizontal-align:            0.0;
        }
        element selected.normal {
            background-color:            var(selected);
            text-color:                  var(background);
        }
      '';
  };
}
