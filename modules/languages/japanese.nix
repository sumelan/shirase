{inputs, ...}: {
  flake.modules.homeManager.japanese = {pkgs, ...}: {
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
        settings = {
          inputMethod = {
            GroupOrder = {
              "0" = "Default";
            };
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "hazkey";
            };
            "Groups/0/Items/0" = {
              Name = "keyboard-us";
              Layout = "";
            };
            "Groups/0/Items/1" = {
              Name = "hazkey";
              Layout = "";
            };
          };
          addons.classicui.globalSection = {
            Theme = "youlan";
            Font = "Noto Sans CJK JP 14";
            MenuFont = "Noto Sans CJK JP 14";
            TrayFont = "Noto Sans CJK JP 14";
            UseDarkTheme = false;
            UseAccentColor = false;
          };
        };
      };
    };

    xdg.dataFile = let
      themeDir = "fcitx5/themes/youlan";
      youlan = file: "${pkgs.fcitx5-mellow-themes}/share/fcitx5/themes/mellow-youlan-dark/${file}";
    in {
      "${themeDir}/highlight.svg".source = youlan "highlight.svg";
      "${themeDir}/panel.svg".source = youlan "panel.svg";
      "${themeDir}/theme.conf".source = youlan "theme.conf";
    };
  };
}
