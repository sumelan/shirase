{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib.custom.colors)
    black0
    black1
    black2
    gray0
    gray1
    gray2
    gray3
    white0
    white2
    white3
    cyan_base
    red_base
    ;
in {
  services.fnott = {
    enable = true;
    extraFlags = [
      # Disables syslog logging. Logging is only done on stderr.
      "-s"
    ];
    settings = let
      soundSrc = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/";
      lowSound = "message.oga";
      normalSound = "message-new-instant.oga";
      warningSound = "dialog-warning.oga";
    in {
      main = {
        icon-theme = config.gtk.iconTheme.name;
        layer = "overlay";

        min-width = 600;
        max-width = 600;

        edge-margin-vertical = 10;
        edge-margin-horizontal = 10;
        notification-margin = 12;

        border-radius = 8;
        border-size = 5;

        selection-helper = ''
          rofi -dmenu -p 'Fnott' -mesg 'Search for notification action...' -theme '${config.xdg.configHome}/rofi/themes/selecter.rasi'
        '';
        play-sound = ''
          pw-play ''${filename}
        '';

        title-format = "[<i>%a%A</i>]";
        title-font = "${config.gtk.font.name}:14";
        summary-format = "<b>%s\\n</b>";
        summary-font = "${config.gtk.font.name}:14";
        body-format = "%b";
        body-font = "${config.gtk.font.name}:14";

        progress-style = "bar";

        idle-timeout = 60;
      };

      low = {
        default-timeout = 5;
        title-color = white3;
        summary-color = white0;
        body-color = white2;
        background = gray3;
        sound-file = soundSrc + lowSound;
      };

      normal = {
        default-timeout = 8;
        title-color = gray0;
        summary-color = gray1;
        body-color = gray2;
        background = cyan_base;
        sound-file = soundSrc + normalSound;
      };

      critical = {
        default-timeout = 0;
        title-color = black0;
        summary-color = black2;
        body-color = black1;
        background = red_base;
        sound-file = soundSrc + warningSound;
      };
    };
  };
}
