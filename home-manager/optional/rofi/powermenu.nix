{config, ...}: let
  monoName = config.stylix.fonts.monospace.name;
  sansSerifName = config.stylix.fonts.sansSerif.name;
  fontSize = config.stylix.fonts.sizes.desktop;
in {
  xdg.configFile."rofi/theme/powermenu.rasi".text = with config.lib.stylix.colors.withHashtag;
  # https://github.com/adi1090x/rofi/blob/master/files/powermenu/type-4/style-3.rasi
  # rasi
    ''
      configuration {
        show-icons:                 false;
      }

      * {
        mainbox-spacing:             50px;
        mainbox-margin:              50px;
        message-margin:              0px 300px;
        message-padding:             12px;
        message-border-radius:       12px;
        listview-spacing:            25px;
        element-padding:             35px 0px;
        element-border-radius:       60px;

        prompt-font:                 "${monoName} Bold ${(fontSize + 10) |> builtins.toString}";
        textbox-font:                "${monoName} ${(fontSize + 0) |> builtins.toString}";
        element-text-font:           "${sansSerifName} Bold ${(fontSize + 10) |> builtins.toString}";

        background-window:           ${base00}E6;
        background-normal:           ${base05}0D;
        background-selected:         ${base05}26;
        foreground-normal:           ${base05}FF;
        foreground-selected:         ${base05}FF;
      }

      /*****----- Main Window -----*****/
      window {
          transparency:                "real";
          location:                    center;
          anchor:                      center;
          fullscreen:                  false;
          width:                       1500px;
          border-radius:               50px;
          cursor:                      "default";
          background-color:            var(background-window);
      }

      /*****----- Main Box -----*****/
      mainbox {
          enabled:                     true;
          spacing:                     var(mainbox-spacing);
          margin:                      var(mainbox-margin);
          background-color:            transparent;
          children:                    [ "dummy", "inputbar", "listview", "message", "dummy" ];
      }

      /*****----- Inputbar -----*****/
      inputbar {
          enabled:                     true;
          background-color:            transparent;
          children:                    [ "dummy", "prompt", "dummy"];
      }

      dummy {
          background-color:            transparent;
      }

      prompt {
          enabled:                     true;
          font:                        var(prompt-font);
          background-color:            transparent;
          text-color:                  var(foreground-normal);
      }

      /*****----- Message -----*****/
      message {
          enabled:                     true;
          margin:                      var(message-margin);
          padding:                     var(message-padding);
          border-radius:               var(message-border-radius);
          background-color:            var(background-normal);
          text-color:                  var(foreground-normal);
      }
      textbox {
          font:                        var(textbox-font);
          background-color:            transparent;
          text-color:                  inherit;
          vertical-align:              0.5;
          horizontal-align:            0.5;
      }

      /*****----- Listview -----*****/
      listview {
          enabled:                     true;
          expand:                      false;
          columns:                     5;
          lines:                       1;
          cycle:                       true;
          dynamic:                     true;
          scrollbar:                   false;
          layout:                      vertical;
          reverse:                     false;
          fixed-height:                true;
          fixed-columns:               true;

          spacing:                     var(listview-spacing);
          background-color:            transparent;
          cursor:                      "default";
      }

      /*****----- Elements -----*****/
      element {
          enabled:                     true;
          padding:                     var(element-padding);
          border-radius:               var(element-border-radius);
          background-color:            var(background-normal);
          text-color:                  var(foreground-normal);
          cursor:                      pointer;
      }
      element-text {
          font:                        var(element-text-font);
          background-color:            transparent;
          text-color:                  inherit;
          cursor:                      inherit;
          vertical-align:              0.5;
          horizontal-align:            0.5;
      }
      element selected.normal {
          background-color:            var(background-selected);
          text-color:                  var(foreground-selected);
      }
    '';
}
