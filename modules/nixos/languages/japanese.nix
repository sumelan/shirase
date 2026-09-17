_: {
  flake.modules.nixos.japanese = {
    pkgs,
    user,
    ...
  }: {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = [pkgs.fcitx5-mozc];
        waylandFrontend = true;
        settings = {
          inputMethod = {
            GroupOrder = {
              "0" = "Default";
            };
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "Mozc";
            };
            "Groups/0/Items/0" = {
              Name = "keyboard-us";
              Layout = "";
            };
            "Groups/0/Items/1" = {
              Name = "Mozc";
              Layout = "";
            };
          };

          addons.classicui.globalSection = {
            Theme = "sakura";
            Font = "Noto Sans CJK JP 14";
            MenuFont = "Noto Sans CJK JP 14";
            TrayFont = "Noto Sans CJK JP 14";
            UseDarkTheme = false;
            UseAccentColor = false;
          };
        };
      };
    };

    hjem.users.${user} = {
      xdg.data.files = let
        themeDir = "fcitx5/themes/sakura";
        sakura = file: "${pkgs.fcitx5-mellow-themes}/share/fcitx5/themes/mellow-sakura-dark/${file}";
      in {
        "${themeDir}/highlight.svg".source = sakura "highlight.svg";
        "${themeDir}/panel.svg".source = sakura "panel.svg";
        "${themeDir}/theme.conf".source = sakura "theme.conf";
      };
    };
  };
}
