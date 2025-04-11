{ config, ... }:
{
  services.swayosd = {
    enable = true;
    topMargin = 1.0;
  };

  home.file = {
    ".config/swayosd/style.css".text = with config.lib.stylix.colors.withHashtag; ''
      window {
        border-radius: 8px;
        border: solid ${base09} 2px;
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
        background: alpha(${base05}, 0.5);
      }

      progress {
        background: ${base05};
      }
    '';
  };
}
