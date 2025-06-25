{
  lib,
  config,
  pkgs,
  ...
}:
with config.lib.stylix.colors.withHashtag;
let
  left-click = 272;
  right-click = 273;

  mediaCmd = pkgs.writers.writeFish "get_media_progress" ''
    if test (playerctl -p spotify status) = Playing
        set length (playerctl -p spotify metadata mpris:length)
        set position (playerctl -p spotify position)
        math $position / $length x 1000000
    else if test (playerctl -p spotify status) = Paused
        set length (playerctl -p spotify metadata mpris:length)
        set position (playerctl -p spotify position)
        math $position / $length x 1000000
    else
        echo -n 0
    end
  '';

  batteryCmd = pkgs.writers.writeFish "get_battery_progress" ''
    set LOW 30
    set CRITICAL 10

    function notify -a 1 2
         notify-send -a "Battery" -i "battery" "$1" "$2"
    end

    set battery (cat /sys/class/power_supply/BAT*/capacity)
    math $battery / 100

    if test $battery -le $LOW
        notify "Battery Low!" "Battery is under $battery%!"
    else if test $battery -le $CRITICAL
        notify "Battery Critical!!" "Battery is under $battery!!"
    end
  '';

  commonConfig = preview: {
    namespace = "progress";
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra-trigger-size = 0;
    preview-size = preview;
    animation-curve = "ease-expo";
    transition-duration = 300;
    ignore-exclusive = true;
    pinnable = true;
    pin-with-key = true;
    pin-key = right-click;
  };

  commonSlider = length: thickness: {
    type = "slider";
    inherit length thickness;
    border-width = 2;
    redraw-only-on-internal-update = true; # this is when you want to reduce the cpu usage
    radius = 20;
    obtuse-angle = 120; # in degrees(90~180). controls how much curve the widget has
    scroll-unit = 0.005;
  };

  mediaConfig = {
    border-color = "${base03}";
    fg-color = "${base0B}";
    bg-color = "${base01}";
    bg-text-color = "${base01}00"; # hide text
    fg-text-color = "${base01}00"; # hide text
    preset = {
      type = "custom";
      update-interval = 500;
      update-command = mediaCmd;
      on-change-command = "";
      event-map = {
        ${builtins.toString left-click} = "playerctl play-pause";
      };
    };
  };

  batteryConfig = {
    border-color = "${base03}";
    fg-color = "${base0A}";
    bg-color = "${base01}";
    bg-text-color = "${base05}";
    fg-text-color = "${base05}";
    preset = {
      type = "custom";
      update-interval = 1000;
      update-command = batteryCmd;
      on-change-command = "";
      event-map = { };
    };
  };

  mediaEdge =
    commonConfig "6%"
    // commonSlider "50%" "0.6%"
    // mediaConfig
    // {
      edge = "bottom";
      position = "right";
      margins.right = "25%";
    };

  batteryEdge =
    commonConfig "6%"
    // commonSlider "8%" "1.5%"
    // batteryConfig
    // {
      edge = "top";
      position = "right";
      margins.right = 0;
    };
in
[
  mediaEdge
]
++ (lib.optional config.custom.battery.enable batteryEdge)
