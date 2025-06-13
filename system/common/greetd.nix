{
  lib,
  config,
  ...
}:
{
  programs.regreet =
    let
      inherit (config.hm.custom) autologinCommand;
    in
    lib.mkIf (autologinCommand != null) {
      enable = true;
      theme = {
        package = config.hm.stylix.iconTheme.package;
        name =
          if config.stylix.polarity == "dark" then
            config.hm.stylix.iconTheme.dark
          else
            config.hm.stylix.iconTheme.light;
      };
      iconTheme = {
        package = config.programs.regreet.theme.package;
        name = config.programs.regreet.theme.name;
      };
      font = {
        package = config.hm.stylix.fonts.sansSerif.package;
        name = config.hm.stylix.fonts.sansSerif.name;
        size = config.hm.stylix.fonts.sizes.desktop;
      };
      cursorTheme = {
        package = config.hm.stylix.cursor.package;
        name = config.hm.stylix.cursor.name;
      };
      settings = {
        default_session = {
          command = autologinCommand;
          user = "greeter";
        };
        background = {
          path = ../../hosts/regreet.jpg;
          fit = "Contain";
        };
        GTK.application_prefer_dark_theme = config.stylix.polarity == "dark";
        appearance.greeting_msg = "Welcome back!";
        widget.clock = {
          format = "%a %H:%M";
          resolution = "500ms";
          label_width = 120 * 4; # the interpretation of this value is entirely up to GTK
        };
      };
      extraCss = with config.lib.stylix.colors.withHashtag; ''
        * {
            all: unset;
          }

          picture {
            filter: blur(1.2rem);
          }

          frame.background {
            background: alpha(${base01}, .92);
            color: ${base05};
            border-radius: 24px;
            box-shadow: 0 0 8px 0 alpha(${base02}, .92);
          }

          frame.background.top {
            font-size: 1.2rem;
            padding: 8px;
            background: ${base01};
            border-radius: 0;
            border-bottom-left-radius: 24px;
            border-bottom-right-radius: 24px;
          }

          box.horizontal>button.default.suggested-action.text-button {
            background: ${base0B};
            color: ${base03};
            padding: 12px;
            margin: 0 8px;
            border-radius: 12px;
            transition: background .3s ease-in-out;
          }

          box.horizontal>button.default.suggested-action.text-button:hover {
            background: shade(${base0B}, 1.2);
          }

          box.horizontal>button.text-button {
            background: ${base01};
            color: ${base06};
            padding: 12px;
            border-radius: 12px;
            transition: background .3s ease-in-out;
          }

          box.horizontal>button.text-button:hover {
            background: shade(${base01}, 1.2);
            color: ${base08};
          }

          combobox {
            background: ${base02};
            color: ${base05};
            border-radius: 12px;
            padding: 12px;
            box-shadow: 0 0 4px 0 alpha(${base02}, .6);
          }

          combobox:disabled {
            background: ${base00};
            color: alpha(${base04}, .6);
            border-radius: 12px;
            padding: 12px;
            box-shadow: 0 0 4px 0 alpha(${base02}, .6);
          }

          modelbutton.flat {
            background: ${base03};
            color: ${base07};
            padding: 6px;
            margin: 2px;
            border-radius: 8px;
            border-spacing: 6px;
          }

          modelbutton.flat:hover {
            background: shade(${base03}, 1.2);
            color: ${base07};
          }

          button.image-button.toggle {
            margin-right: 36px;
            padding: 12px;
            border-radius: 12px;
          }

          button.image-button.toggle:hover {
            background: ${base01};
            box-shadow: 0 0 4px 0px alpha(${base02}, .6);
          }

          button.image-button.toggle:disabled {
            background: ${base00};
            color: alpha(${base04}, .6);
            margin-right: 36px;
            padding: 12px;
            border-radius: 12px;
          }

          combobox>popover {
            background: ${base02};
            color: ${base04};
            border-radius: 8px;
            border-spacing: 6px;
            box-shadow: 0 0 4px 0 alpha(${base02}, .6);
            padding: 6px 12px;
          }

          combobox>popover>contents {
            padding: 2px;
          }

          combobox:hover {
            background: shade(${base02}, 1.2);
          }

          entry.password {
            border: 2px solid ${base0D};
            border-radius: 12px;
            padding: 12px;
          }

          entry.password:hover {
            border: 2px solid ${base0D};
          }
      '';
    };

  custom.persist = {
    root.directories = [
      "/var/lib/regreet"
    ];
  };
}
