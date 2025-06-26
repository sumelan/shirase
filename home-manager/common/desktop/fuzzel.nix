{
  lib,
  config,
  pkgs,
  isLaptop,
  ...
}:
let
  opacity = config.stylix.opacity.popups * 255 |> builtins.ceil |> lib.toHexString;

  wfCmd = pkgs.writers.writeFish "recorder" ''
    set TMP_FILE_UNOPTIMIZED "/tmp/recording_unoptimized.gif"
    set TMP_PALETTE_FILE "/tmp/palette.png"
    set TMP_MP4_FILE "/tmp/recording.mp4"
    set TMP_GIF_RESULT "/tmp/gif_result"
    set APP_NAME "Recorder"

    set OUT_DIR "$HOME/Videos"
    set filename (date +"%Y-%m-%d_%H-%M-%S")
    set FILENAME "$OUT_DIR/$filename."

    function print_help
        echo "Usage: record.fish [flags]"
        echo
        echo "Start a screen recording or stop a running one"
        echo
        echo "flags:"
        echo " -h, --help   Display this help message"
        echo " -s, --screen   Record screen"
        echo " -a, --area   Record selected area"
        echo " -g, --gif   Record screen and converted to gif"
        echo " -q, --quit   Stop screen recording"
    end


    function is_recorder_running
        ${lib.getExe' pkgs.procps "pgrep"} -x "wf-recorder" > /dev/null
    end

    function convert_to_gif
        ffmpeg -i "$TMP_MP4_FILE" -filter_complex "[0:v] palettegen" "$TMP_PALETTE_FILE"
        ffmpeg -i "$TMP_MP4_FILE" -i "$TMP_PALETTE_FILE" -filter_complex "[0:v] fps=10,scale=1400:-1,setpts=0.5*PTS [new];[new][1:v] paletteuse" "$TMP_FILE_UNOPTIMIZED"
        if [ -f "$TMP_PALETTE_FILE" ]
            rm "$TMP_PALETTE_FILE"
        end
        if [ -f "$TMP_MP4_FILE" ]
            rm "$TMP_MP4_FILE"
        end
        ${lib.getExe' pkgs.gifsicle "gifsicle"} -O3 --lossy=100 -i "$TMP_FILE_UNOPTIMIZED" -o "$TMP_GIF_RESULT"
        if [ -f "$TMP_FILE_UNOPTIMIZED" ]
            rm "$TMP_FILE_UNOPTIMIZED"
        end
    end

    function notify -a 1 2
        ${lib.getExe' pkgs.libnotify "notify-send"} -a "$APP_NAME" "$1" "$2"
    end

    function screen
        notify "Starting Recording" "Your screen is being recorded"
        timeout 600 ${lib.getExe pkgs.wf-recorder} -F format=rgb24 -x rgb24 -p qp=0 -p crf=0 -p preset=slow -c libx264rgb -f "$TMP_MP4_FILE"
    end

    function area
        set GEOMETRY (${lib.getExe pkgs.slurp})
        if test "$GEOMETRY" != ""
            notify "Starting Recording" "Your screen is being recorded"
            timeout 600 ${lib.getExe pkgs.wf-recorder} -F format=rgb24 -x rgb24 -p qp=0 -p crf=0 -p preset=slow -c libx264rgb -g "$GEOMETRY" -f "$TMP_MP4_FILE"
        end
    end

    function gif
        touch /tmp/recording_gif
        area
    end

    function stop
        if is_recorder_running
            kill (pgrep -x wf-recorder)

            if test -f /tmp/recording_gif
                notify "Stopped Recording" "Starting GIF conversion phase..."
                set FILENAME "gif"
                convert_to_gif
                set SavePath (${lib.getExe pkgs.zenity} --file-selection --save --file-filter="*.gif" --filename=.gif)
                if not string match '*.gif' $SavePath; set SavePath '.gif'; end
                mv $TMP_GIF_RESULT $SavePath
                wl-copy -t image/png < $SavePath
                notify "GIF conversion completed" "GIF saved to $SavePath"
            else
                set FILENAME "mp4"
                set SavePath (${lib.getExe pkgs.zenity} --file-selection --save --file-filter="*.mp4" --filename=.mp4)
                if not string match '*.mp4' $SavePath; set SavePath '.mp4'; end
                mv $TMP_MP4_FILE $SavePath
                wl-copy -t video/mp4 < $SavePath
                notify "Stopped Recording" "Video saved to $SavePath"
            end

            if test -f $TMP_FILE_UNOPTIMIZED; rm -f "$TMP_FILE_UNOPTIMIZED"; end
            if test -f $TMP_PALETTE_FILE; rm -f "$TMP_PALETTE_FILE"; end
            if test -f $TMP_GIF_RESULT; rm -f "$TMP_GIF_RESULT"; end
            if test -f $TMP_MP4_FILE; rm -f "$TMP_MP4_FILE"; end
            if test -f /tmp/recording_gif; rm -f /tmp/recording_gif; end

            exit 0
        end
    end

    # =====main=====

    if [ ! -d "$OUT_DIR" ]
        mkdir -p "$OUT_DIR"
    end

    if is_recorder_running
        stop
    end

    set options h/help
    set options $options s/screen
    set options $options a/area
    set options $options q/quit
    set options $options g/gif

    argparse $options -- $argv
    or return

    if set -ql _flag_help
        print_help
        return
    end

    if set -ql _flag_screen
        screen
        return
    end

    if set -ql _flag_area
        area
        return
    end

    if set -ql _flag_gif
        gif
        return
    end

    if set -ql _flags_quit
        if test -f $TMP_FILE_UNOPTIMIZED; rm -f "$TMP_FILE_UNOPTIMIZED"; end
        if test -f $TMP_PALETTE_FILE; rm -f "$TMP_PALETTE_FILE"; end
        if test -f $TMP_GIF_RESULT; rm -f "$TMP_GIF_RESULT"; end
        if test -f $TMP_MP4_FILE; rm -f "$TMP_MP4_FILE"; end
        if test -f /tmp/recording_gif; rm -f /tmp/recording_gif; end
        stop
        return
    end
  '';

  actionCmd = pkgs.writers.writeFish "fuzzel-actions" ''
    set choices " Lock
     Suspend
    󰿅 Exit
     Reboot
     Poweroff
    󰸉 Change-Wallpaper"

    set choice (echo -en $choices | fuzzel --dmenu --prompt " " --placeholder "Search for System actions..." --lines 6)

    switch (string split -f 2 " " $choice)
        case Lock
            ${lib.getExe pkgs.hyprlock}
        case Suspend
            systemctl suspend
        case Exit
            niri msg action quit
        case Reboot
            systemctl reboot
        case Poweroff
            systemctl poweroff
        case Change-Wallpaper
            ${lib.getExe' pkgs.wpaperd "wpaperctl"} next
    end
  '';

  recordCmd = pkgs.writers.writeFish "fuzzel-recorder" ''
    set choices " Record-Screen
     Record-Area
    󰵸 Record-toGif
     Quit-Recording"

    set choice (echo -en $choices | fuzzel --dmenu --prompt " " --placeholder "Search for Recorder actions..." --lines 4)

    switch (string split -f 2 " " $choice)
        case Record-Screen
            ${wfCmd} -s
        case Record-Area
            ${wfCmd} -a
        case Record-toGif
            ${wfCmd} -g
        case Quit-Recording
            ${wfCmd} -q
    end
  '';

  clipCmd = pkgs.writers.writeFish "fuzzel-clipboard" ''
    ${lib.getExe pkgs.cliphist} list | fuzzel --dmenu --prompt "󰅇 " --placeholder "Search for clipboard entries..." --no-sort | ${lib.getExe pkgs.cliphist} decode | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}
  '';

  windowCmd = pkgs.writers.writeFish "fuzzel-windows" ''
    set windows (niri msg -j windows)
    set ids (echo $windows | jq -r '.[] | .id')
    set app_ids (echo $windows | jq -r '.[] | .app_id' )
    set titles (echo $windows | jq -r '.[] | .title' )
    set choices ""

    for i in (seq (count $ids))
      set choices "$choices$titles[$i]\t$app_ids[$i]\0icon\x1f$app_ids[$i]\n"
    end

    set choices (string trim -c "\n" $choices)

    set choice (echo -e $choices | fuzzel --counter --dmenu --prompt " " --placeholder "Search for windows..." --index --tabs 200 || exit)
    if [ "x$choice" != "x" ] && [ $choice != -1 ]
      niri msg action focus-window --id $ids[(math $choice + 1)]
    end
  '';
in
{
  programs = {
    fuzzel = {
      enable = true;
      settings = {
        main = {
          layer = "overlay";
          placeholder = "Type to search...";
          prompt = "'❯ '";
          font =
            with config.stylix.fonts;
            let
              sizeParamater = if isLaptop then 2 else (-2);
            in
            "${sansSerif.name}:size=${sizes.popups - sizeParamater |> builtins.toString}";
          icon-theme = config.stylix.iconTheme.dark;
          match-counter = true;
          terminal = "${config.custom.terminal.exec}";
          width = 24;
          lines = 12;
          horizontal-pad = 25;
          vertical-pad = 8;
          inner-pad = 5;
        };
        border = {
          width = 2;
          radius = 10;
        };
        colors = with config.lib.stylix.colors; {
          background = "${base00-hex}${opacity}";
          border = "${base0B-hex}ff";
          counter = "${base06-hex}ff";
          input = "${base05-hex}ff";
          match = "${base0A-hex}ff";
          placeholder = "${base03-hex}ff";
          prompt = "${base05-hex}ff";
          selection = "${base03-hex}ff";
          selection-match = "${base0A-hex}ff";
          selection-text = "${base05-hex}ff";
          text = "${base05-hex}ff";
        };
      };
    };
    niri.settings.binds =
      with config.lib.niri.actions;
      let
        ush = program: spawn "sh" "-c" "uwsm app -- ${program}";
      in
      {
        "Mod+D" = {
          action = ush "fuzzel";
          hotkey-overlay.title = "Fuzzel";
        };
        "Alt+Escape" = {
          action = ush windowCmd;
          hotkey-overlay.title = "Windows Search";
        };
        "Mod+R" = {
          action = ush recordCmd;
          hotkey-overlay.title = "Recorder";
        };
        "Mod+Q" = {
          action = ush actionCmd;
          hotkey-overlay.title = "System Actions";
        };
        "Mod+V" = {
          action = ush clipCmd;
          hotkey-overlay.title = "Show Clipboard History";
        };
      };
  };
  stylix.targets.fuzzel.enable = false;
}
