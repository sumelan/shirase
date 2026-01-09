{inputs, ...}: {
  flake.modules.homeManager.japanese = {
    config,
    pkgs,
    ...
  }: let
    regularFont = config.gtk.font.name;
  in {
    custom.fonts.packages = [
      pkgs.noto-fonts-cjk-sans
    ];

    services.hazkey = {
      enable = true;
      # llama backend
      # - libllama-cpu - CPU (default)
      # - libllama-vulkan - GPU (Vulkan)
      libllama.package = inputs.nix-hazkey.packages.${pkgs.stdenv.hostPlatform.system}.libllama-cpu;
      # zenzai model
      # - zenzai_v3_1-small (default)
      # - zenzai_v3_1-xsmall
      # - zenzai_v3-small
      # - zenzai_v2
      zenzai.package = inputs.nix-hazkey.packages.${pkgs.stdenv.hostPlatform.system}.zenzai_v3_1-small;
    };

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        themes.nord = {
          highlightImage = "${pkgs.fcitx5-nord}/share/fcitx5/themes/Nord-Dark/arrow.png";
          panelImage = "${pkgs.fcitx5-nord}/share/fcitx5/themes/Nord-Dark/radio.png";
          theme = {
            Metadata = {
              Name = "Nord-Dark";
              Version = 0.1;
              Author = "tonyfettes";
              Description = "Nord Color Theme (Dark)";
              ScaleWithDPI = true;
            };
            InputPanel = {
              Font = "${regularFont} 13";
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
              Font = "${regularFont} 10";
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
          Font = "${regularFont} 14";
          MenuFont = "${regularFont} 14";
          TrayFont = "${regularFont} 14";
          UseDarkTheme = false;
          UseAccentColor = false;
        };
      };
    };
  };
}
