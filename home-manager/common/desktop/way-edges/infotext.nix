{
  lib,
  config,
  pkgs,
  isLaptop,
  ...
}:
with config.lib.stylix.colors.withHashtag;
let
  right-click = 273;

  mediaCmd = pkgs.writers.writeFish "get_media_text" ''
    if test (playerctl -p spotify status) = Playing
        set artist (playerctl -p spotify metadata xesam:artist)
        set title (playerctl -p spotify metadata xesam:title)
        echo " $artist - $title"
    else if test (playerctl -p spotify status) = Paused
        echo " - Paused -"
    end
  '';

  batteryCmd = pkgs.writers.writeFish "get_battery_text" ''
    set battery (cat /sys/class/power_supply/BAT*/capacity)
    set battery_status (cat /sys/class/power_supply/BAT*/status)

    set charging_icons 󰢜 󰂆 󰂇 󰂈 󰢝 󰂉 󰢞 󰂊 󰂋 󰂅
    set discharging_icons 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹

    set icon (math round\($battery/10\))

    if test $battery_status = Full
        echo "$charging_icons[10] Battery full"
    else if test $battery_status = Discharging
        echo "$discharging_icons[$icon] Discharging"
    else if test $battery_status = "Not charging"
        echo "$charging_icons[$icon] Battery charged"
    else
        echo "$charging_icons[$icon] Charging"
    end
  '';

  dateCmd = pkgs.writers.writeFish "get_date_text" ''
    date +" %m/%d |  %H:%M"
  '';

  commonConfig = edge: position: margin: {
    namespace = "info";
    inherit edge position;
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra-trigger-size = 0;
    preview-size = "8%";
    animation-curve = "ease-expo";
    transition-duration = 300;
    margins.${position} = margin;
    ignore-exclusive = true;
    pinnable = true;
    pin-with-key = true;
    pin-key = right-click;
    type = "wrap-box";
    align = "center-right";
    gap = 10;
    outlook = {
      type = "window";
      color = "${base01}";
      border-radius = 8;
      border-width = 2;
      margins = {
        left = 10;
        right = 10;
        bottom = 10;
        top = 10;
      };
    };
  };

  textConfig = color: cmd: {
    index = [
      (-1)
      (-1)
    ];
    type = "text";
    fg-color = color;
    font-family = "${config.stylix.fonts.monospace.name}";
    font-size =
      let
        sizeParameter = if isLaptop then 5 else 12;
      in
      config.stylix.fonts.sizes.desktop + sizeParameter;
    preset = {
      type = "custom";
      inherit cmd;
      update-interval = 1000;
    };
  };

  mediaEdge = commonConfig "right" "bottom" "2%" // {
    items = [
      (textConfig "${base0B}" "${mediaCmd}")
    ];
  };

  dateEdge = commonConfig "top" "right" "45%" // {
    items = [
      (textConfig "${base05}" "${dateCmd}")
    ];
  };

  batteryEdge = commonConfig "right" "top" "2%" // {
    items = [
      (textConfig "${base0A}" "${batteryCmd}")
    ];
  };
in
[
  mediaEdge
  dateEdge
]
++ (lib.optional config.custom.battery.enable batteryEdge)
