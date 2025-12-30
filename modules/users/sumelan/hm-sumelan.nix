{
  config,
  pkgs,
  ...
}: {
  flake.modules.homeManager.user_sumelan = {
    home.file.".face".source = ./sumelan.png;

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = [pkgs.fcitx5-mozc];
        waylandFrontend = true;
        themes.nord = {
          highlightImage = "${pkgs.fcitx5-nord}/Nord-Dark/arrow.png";
          panelImage = "${pkgs.fcitx5-nord}/Nord-Dark/radio.png";
          theme = {
            Metadata = {
              Name = "Nord-Dark";
              Version = 0.1;
              Author = "tonyfettes";
              Description = "Nord Color Theme (Dark)";
              ScaleWithDPI = true;
            };
            InputPanel = {
              Font = "${config.hm.custom.fonts.regular} 13";
              NormalColor = "#81a1c1";
              HighlightCandidateColor = "#88c0d0";
              HighlightColor = "#88c0d0";
              HighlightBackgroundColor = "#434c5e";
              Spacing = 3;
            };
            "InputPanel/TextMargin" = {
              Left = 10;
              Right = 10;
              Top = 6;
              Bottom = 6;
            };
            "InputPanel/Background" = {
              Color = "#434c5e";
            };
            "InputPanel/Background/Margin" = {
              Left = 2;
              Right = 2;
              Top = 2;
              Bottom = 2;
            };
            "InputPanel/Highlight" = {
              Color = "#4c566a";
            };
            "InputPanel/Highlight/Margin" = {
              Left = 10;
              Right = 10;
              Top = 7;
              Bottom = 7;
            };
            Menu = {
              Font = "${config.hm.custom.fonts.regular} 10";
              NormalColor = "#eceff4";
              # HighlightColor="#4c566a";
              Spacing = 3;
            };
            "Menu/Background" = {
              Color = "#434c5e";
            };
            "Menu/Background/Margin" = {
              Left = 2;
              Right = 2;
              Top = 2;
              Bottom = 2;
            };
            "Menu/ContentMargin" = {
              Left = 2;
              Right = 2;
              Top = 2;
              Bottom = 2;
            };
            "Menu/Highlight" = {
              Color = "#4c566a";
            };
            "Menu/Highlight/Margin" = {
              Left = 10;
              Right = 10;
              Top = 5;
              Bottom = 5;
            };
            "Menu/Separator" = {
              Color = "#2e3440";
            };
            "Menu/CheckBox" = {
              Image = "radio.png";
            };
            "Menu/SubMenu" = {
              Image = "arrow.png";
            };
            "Menu/TextMargin" = {
              Left = 5;
              Right = 5;
              Top = 5;
              Bottom = 5;
            };
          };
        };
        settings.addons.classicui.globalSection = {
          Theme = "nord";
          Font = "${config.hm.custom.fonts.regular} 14";
          MenuFont = "${config.hm.custom.fonts.regular} 14";
          TrayFont = "${config.hm.custom.fonts.regular} 14";
          UseDarkTheme = false;
          UseAccentColor = false;
        };
      };
    };
  };
}
