{ config, ... }:
{
  programs.waybar.style =
    with config.lib.stylix.colors.withHashtag;
    let
      trayBackgroundColor = if config.stylix.polarity == "dark" then "${base00}" else "${base05}";
      tray-css =
        # css
        ''
          #tray {
            background: shade(alpha(${trayBackgroundColor}, 0.9), 1);
          }
        '';

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
    # css
    ''
      ${animation-css}

      * {
        /* all: unset; */
        font-family: "Maple Mono NF";
        font-weight: bold;
        font-size: ${builtins.toString (config.stylix.fonts.sizes.desktop + 6)}px;
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
        border-color: ${base09};
      }

      #image,
      #idle_inhibitor,
      #clock,
      #wireplumber,
      #backlight,
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
        background: radial-gradient(circle, ${base08} 0%, ${base0D} 100%);
        background-size: 400% 400%;
        animation: gradient_f 40s ease-in-out infinite;
        transition: all 0.3s cubic-bezier(0.55, -0.68, 0.48, 1.682);
      }

      #idle_inhibitor.activated {
        color: ${base00};
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

      ${tray-css}

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }
    '';
}
