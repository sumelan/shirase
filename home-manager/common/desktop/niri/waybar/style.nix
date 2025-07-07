{ config, ... }:
{
  programs.waybar.style =
    with config.lib.stylix.colors.withHashtag;
    let
      animation-css =
        # css
        ''
          @keyframes gradient {
            0% {
              background-position: 0% 50%;
            }
            50% {
              background-position: 100% 30%;
            }
            100% {
              background-position: 0% 50%;
            }
          }

          @keyframes gradient_f {
            0% {
              background-position: 0% 200%;
            }
            50% {
              background-position: 200% 0%;
            }
            100% {
              background-position: 400% 200%;
            }
          }

          @keyframes gradient_f_nh {
            0% {
              background-position: 0% 200%;
            }
            100% {
              background-position: 200% 200%;
            }
          }

          @keyframes gradient_rv {
            0% {
              background-position: 200% 200%;
            }
            100% {
              background-position: 0% 200%;
            }
          }
        '';
    in
    lib.mkIf config.cutsom.niri.enable
      # css
      ''
        ${animation-css}

        * {
          /* all: unset; */
          font-family: "${config.stylix.fonts.monospace.name}";
          font-weight: bold;
          font-size: ${builtins.toString (config.stylix.fonts.sizes.desktop + 5)}px;
          min-height: 0;
        }

        window#waybar {
          background: transparent;
        }

        tooltip {
          background: ${base01};
          border-radius: 5px;
          border-width: 2px;
          border-style: solid;
          border-color: ${base0B};
        }

        #image,
        #idle_inhibitor,
        #clock,
        #wireplumber,
        #backlight,
        #battery,
        #tray,
        #window {
          padding: 5px 10px;
          background: shade(alpha(${base00}, 0.9), 1);
          text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.377);
          color: ${base05};
          margin-top: 5px;
          margin-bottom: 4px;
          margin-left: 5px;
          margin-right: 5px;
          box-shadow: 1px 2px 2px #101010;
          border-radius: 10px;
        }

        #image {
          padding: 6px 6px;
          border-radius: 20px;
        }

        #idle_inhibitor {
          padding: 6px 6px;
          border-radius: 20px;
        }

        #idle_inhibitor.activated {
          padding: 6px 6px;
          border-radius: 20px;
          background: shade(alpha(${base0D}, 0.9), 1);
        }

        #window {
          color: ${base00};
          background: radial-gradient(circle, ${base05} 0%, ${base0B} 100%);
          background-size: 400% 400%;
          animation: gradient_f 40s ease-in-out infinite;
          transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
        }

        window#waybar.empty #window {
          background: none;
          background-color: transparent;
          box-shadow: none;
        }

        #battery {
          background: ${base0F};
          background: linear-gradient(
            118deg,
            ${base0E} 5%,
            ${base0D} 5%,
            ${base0D} 20%,
            ${base0E} 20%,
            ${base0E} 40%,
            ${base0D} 40%,
            ${base0D} 60%,
            ${base0E} 60%,
            ${base0E} 80%,
            ${base0D} 80%,
            ${base0D} 95%,
            ${base0E} 95%
          );
          background-size: 200% 300%;
          animation: gradient_f_nh 6s linear infinite;
          color: ${base01};
        }

        #battery.charging,
        #battery.plugged {
          background: linear-gradient(
            118deg,
            ${base0B} 5%,
            ${base0C} 5%,
            ${base0C} 20%,
            ${base0B} 20%,
            ${base0B} 40%,
            ${base0C} 40%,
            ${base0C} 60%,
            ${base0B} 60%,
            ${base0B} 80%,
            ${base0C} 80%,
            ${base0C} 95%,
            ${base0B} 95%
          );
          background-size: 200% 300%;
          animation: gradient_rv 4s linear infinite;
        }

        #battery.full {
          background: linear-gradient(
            118deg,
            ${base0B} 5%,
            ${base0C} 5%,
            ${base0C} 20%,
            ${base0B} 20%,
            ${base0B} 40%,
            ${base0C} 40%,
            ${base0C} 60%,
            ${base0B} 60%,
            ${base0B} 80%,
            ${base0C} 80%,
            ${base0C} 95%,
            ${base0B} 95%
          );
          background-size: 200% 300%;
          animation: gradient_rv 20s linear infinite;
        }

        #tray {
          background: shade(alpha(${base00}, 0.9), 1);
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
        }
      '';
}
