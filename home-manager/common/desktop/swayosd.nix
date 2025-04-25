{ config, user, ... }:
{
  services.swayosd = {
    enable = true;
    stylePath = "/home/${user}/.config/swayosd/style.scss";
    topMargin = 1.0;
  };

  home.file = {
    ".config/swayosd/style.scss".text = with config.lib.stylix.colors.withHashtag; ''
      window {
        border-radius: 999px;
        border: none;
        background: alpha(${base00}, ${toString config.stylix.opacity.popups});
      }

      image,
      label {
        color: ${base05};
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
