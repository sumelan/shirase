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

  mediaCmd = pkgs.writers.writeFish "write_media_text" ''
    set MAXINFO 28

    if test (playerctl -p spotify status) = Playing
        set artist (playerctl -p spotify metadata xesam:artist)
        set title (playerctl -p spotify metadata xesam:title)
        set info " $artist - $title"
        if test (string length $info) -gt $MAXINFO
            set short (string shorten -m $MAXINFO $info)
            echo "$short"
        else
            echo "$info"
        end

    else if test (playerctl -p spotify status) = Paused
        echo " - Paused -"
    end
  '';

  batteryCmd = pkgs.writers.writeFish "write_battery_text" ''
    function power_profile
        set ppd (powerprofilesctl get)
        if string match $ppd "power-saver" > /dev/null
            echo " "
        else if string match $ppd "balanced" > /dev/null
            echo " "
        else
            echo " "
        end
    end

    set battery (cat /sys/class/power_supply/BAT*/capacity)
    set battery_status (cat /sys/class/power_supply/BAT*/status)

    set charging_prefixs "" "" "" "" "" "" "" "" "" "󱈏"
    set discharging_prefixs "Critical!!" "Causion!" "Low" "" "" "" "" "" "" ""

    set prefix (math round\($battery/10\))

    set profile (power_profile)

    if test $battery_status = Full
        echo "$charging_prefixs[10] $profile | Full Charged!!"
    else if test $battery_status = Discharging
        echo "$discharging_prefixs[$prefix] $profile | No Connection"
    else if test $battery_status = "Not charging"
        echo "$charging_prefixs[$prefix] $profile | Battery Charged!"
    else
        echo "$charging_prefixs[$prefix] $profile | Connected"
    end
  '';

  dateCmd = pkgs.writers.writeFish "write_date_text" ''
    date +" %m/%d |  %H:%M"
  '';

  recorderCmd = pkgs.writers.writeFish "write_recorder_state" ''
    function is_recorder_running
        ${lib.getExe' pkgs.procps "pgrep"} -x "wf-recorder" > /dev/null
    end

    function is_convert_processing
        ${lib.getExe' pkgs.procps "pgrep"} -x "ffmpeg" > /dev/null
    end

    if is_recorder_running
        echo " Recorder running..."
    else if is_convert_processing
        echo " Converting to gif..."
    end
  '';

  commonConfig = edge: position: margin: {
    namespace = "info";
    inherit edge position;
    layer = "overlay";
    monitor = config.lib.monitors.mainMonitorName;
    extra-trigger-size = 0;
    preview-size = "10%";
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

  recorderEdge = commonConfig "right" "top" "6%" // {
    items = [
      (textConfig "${base08}" "${recorderCmd}")
    ];
  };

  dateEdge = commonConfig "top" "right" "44.5%" // {
    items = [
      (textConfig "${base05}" "${dateCmd}")
    ];
  };

  batteryEdge = commonConfig "right" "top" "2%" // {
    items = [
      (textConfig "${base0B}" "${batteryCmd}")
    ];
  };
in
[
  mediaEdge
  recorderEdge
  dateEdge
]
++ (lib.optional config.custom.battery.enable batteryEdge)
