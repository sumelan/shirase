#!/usr/bin/env fish

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
    pgrep -x wf-recorder > /dev/null
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
    gifsicle -O3 --lossy=100 -i "$TMP_FILE_UNOPTIMIZED" -o "$TMP_GIF_RESULT"
    if [ -f "$TMP_FILE_UNOPTIMIZED" ]
        rm "$TMP_FILE_UNOPTIMIZED"
    end
end

function notify -a 1 2
    notify-send -a "$APP_NAME" "$1" "$2" -t 600000
end

function screen
    notify "Starting Recording" "Your screen is being recorded"
    timeout 600 wf-recorder -F format=rgb24 -x rgb24 -p qp=0 -p crf=0 -p preset=slow -c libx264rgb -f "$TMP_MP4_FILE"
end

function area
    set GEOMETRY (slurp)
    if test "$GEOMETRY" != ""
        notify "Starting Recording" "Your screen is being recorded"
        timeout 600 wf-recorder -F format=rgb24 -x rgb24 -p qp=0 -p crf=0 -p preset=slow -c libx264rgb -g "$GEOMETRY" -f "$TMP_MP4_FILE"
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
            set SavePath (zenity --file-selection --save --file-filter="*.gif" --filename=.gif)
            if not string match '*.gif' $SavePath; set SavePath '.gif'; end
            mv $TMP_GIF_RESULT $SavePath
            wl-copy -t image/png < $SavePath
            notify "GIF conversion completed" "GIF saved to $SavePath"
        else
            set FILENAME ".mp4"
            set SavePath (zenity --file-selection --save --file-filter="*.mp4" --filename=.mp4)
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
