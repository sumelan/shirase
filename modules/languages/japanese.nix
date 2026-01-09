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
        settings.addons.classicui.globalSection = {
          Theme = "sakura";
          Font = "${regularFont} 14";
          MenuFont = "${regularFont} 14";
          TrayFont = "${regularFont} 14";
          UseDarkTheme = false;
          UseAccentColor = false;
        };
      };
    };

    xdg.dataFile = let
      sakura = file: "${pkgs.fcitx5-mellow-themes}/share/fcitx5/themes/mellow-sakura-dark/${file}";
    in {
      "fcitx5/themes/sakura/highlight.svg".source = sakura "highlight.svg";
      "fcitx5/themes/sakura/panel.svg".source = sakura "panel.svg";
      "fcitx5/themes/sakura/theme.conf".source = sakura "theme.conf";
    };
  };
}
