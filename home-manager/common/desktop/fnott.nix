{
  lib,
  config,
  pkgs,
  ...
}:
{
  services.fnott = {
    enable = true;
    settings =
      let
        font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}";
        fg = c: "${c}ff";
        bg =
          c:
          "${c}${
            lib.toHexString (((builtins.floor (config.stylix.opacity.popups * 100 + 0.5)) * 255) / 100)
          }";
      in
      with config.lib.stylix.colors;
      {
        main = {
          # Global values
          min-width = 0;
          max-width = 0;
          max-height = 0;
          anchor = "bottom-right";
          edge-margin-vertical = 10;
          edge-margin-horizontal = 10;
          notification-margin = 10;
          icon-theme = config.stylix.iconTheme.dark;
          selection-helper = "fuzzel --dmenu0 --prompt \"󰛰 \" --placeholder \"Search for notification action...\"";
          selection-helper-uses-null-separator = true;

          # Default values
          layer = "top";
          background = bg base01;

          border-size = 2;
          border-radius = 8;

          title-font = font;
          title-color = fg base05;
          title-format = "<i>%a%A<i>";

          summary-font = font;
          summary-color = fg base05;
          summary-format = "<b>%s</b>";

          body-font = font;
          body-color = fg base05;
          body-format = "%b";

          progress-bar-height = 20;
          progress-bar-color = fg base04;

          max-timeout = 30;
          default-timeout = 8;
          idle-timeout = 60;
        };

        low = {
          border-color = fg base0C;
          default-timeout = 4;
        };
        normal = {
          border-color = fg base09;
          default-timeout = 6;
        };
        critical = {
          border-color = fg base08;
          default-timeout = 0;
        };
      };
  };
  home.packages = with pkgs; [ libnotify ];
}
