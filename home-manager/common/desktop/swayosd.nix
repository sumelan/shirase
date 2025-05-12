{ config, user, ... }:
{
  services.swayosd = {
    enable = true;
    # NOTE: options "swayosd.display" exists, but not work
    stylePath = "/home/${user}/.config/swayosd/style.scss";
    topMargin = 1.0;
  };

  home.file = {
    ".config/swayosd/style.scss".text = with config.lib.stylix.colors.withHashtag; ''
      window {
        border-radius: 999px;
        border: 2px solid alpha(${base09}, ${toString config.stylix.opacity.popups});
        background: alpha(${base00}, ${toString config.stylix.opacity.popups});
      }

      image,
      label {
        color: ${base05};
      }

      progressbar {
        min-height: 6px;
        border-radius: 999px;
        background: transparent;
        border: none;
      }

      progressbar:disabled,
      image:disabled {
        opacity: 0.5;
      }

      trough {
        min-height: inherit;
        border-radius: inherit;
        border: none;
        background: alpha(${base05}, 0.5);
      }

      progress {
        min-height: inherit;
        border-radius: inherit;
        border: none;
        background: ${base05};
      }
    '';
  };
}
