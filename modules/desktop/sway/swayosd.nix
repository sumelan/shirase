_: let
  inherit (builtins) toString;
in {
  flake.modules.homeManager.default = {config, ...}: let
    gray0 = "#242933";
    gray2 = "#3B4252";
    white2 = "#E5E9F0";
    inherit (config.xdg) configHome;
  in {
    services.swayosd = {
      enable = true;
      stylePath = "${configHome}/swayosd/style.scss";
      topMargin = 1.0;
    };

    xdg.configFile."swayosd/style.scss".text =
      # scss
      ''
        window {
          border-radius: 999px;
          border: 2px solid alpha(${gray2}, ${toString 0.85});
          background: alpha(${gray0}, ${toString 0.85});
        }

        image,
        label {
          color: ${white2};
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
          background: alpha(${white2}, 0.5);
        }

        progress {
          min-height: inherit;
          border-radius: inherit;
          border: none;
          background: ${white2};
        }
      '';
  };
}
