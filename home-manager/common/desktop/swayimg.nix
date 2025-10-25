{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) getExe singleton;
  # Black
  black0 = "#191D24";
  black1 = "#1E222A";
  black2 = "#222630";

  # Gray
  gray0 = "#242933";
  # Polar night
  gray1 = "#2E3440";
  gray2 = "#3B4252";
  gray3 = "#434C5E";
  gray4 = "#4C566A";
  # a light blue/gray
  # from @nightfox.nvim
  gray5 = "#60728A";

  # White
  # reduce_blue variant
  white0 = "#C0C8D8";
  # Snow storm
  white1 = "#D8DEE9";
  white2 = "#E5E9F0";
  white3 = "#ECEFF4";

  # Blue
  # Frost
  blue0 = "#5E81AC";
  blue1 = "#81A1C1";
  blue2 = "#88C0D0";

  # Cyan:
  cyan_base = "#8FBCBB";
  cyan_bright = "#9FC6C5";
  cyan_dim = "#80B3B2";

  # Aurora (from Nord theme)
  # Red
  red_base = "#BF616A";
  red_bright = "#C5727A";
  red_dim = "#B74E58";

  # Orange
  orange_base = "#D08770";
  orange_bright = "#D79784";
  orange_dim = "#CB775D";

  # Yellow
  yellow_base = "#EBCB8B";
  yellow_bright = "#EFD49F";
  yellow_dim = "#E7C173";

  # Green
  green_base = "#A3BE8C";
  green_bright = "#B1C89D";
  green_dim = "#97B67C";

  # Magenta
  magenta_base = "#B48EAD";
  magenta_bright = "#BE9DB8";
  magenta_dim = "#A97EA1";
in {
  programs = {
    swayimg = {
      enable = true;
      settings = let
        swayimgOpacity =
          lib.toHexString (((builtins.floor (0.95 * 100 + 0.5)) * 255) / 100);
      in {
        general = {
          mode = "viewer";
          position = "auto";
          size = "image"; # Window size (fullscreen/parent/image, or absolute size, e.g. 800,600)
          decoration = "no";
          sigusr1 = "reload"; # Action performed by SIGUSR1 signal (same format as for key bindings)
          sigusr2 = "next_file"; # Action performed by SIGUSR2 signal (same format as for key bindings)
          app_id = "swayimg";
        };
        viewer = {
          window = gray1 + swayimgOpacity; # Window background color (blur/RGBA)
          transparency = "grid";
          scale = "optimal"; # Default image scale (optimal/width/height/fit/fill/real/keep)
          position = "center";
          antialiasing = "mks13";
          history = 1;
          preload = 1;
          loop = "yes";
        };
        slideshow = {
          # Slideshow image display time (seconds)
          time = 3;
          # Window background color (auto/extend/mirror/RGBA)
          window = "auto";
          # Background for transparent images (grid/RGBA)
          transparency = "#000000ff";
          # Default image scale (optimal/width/height/fit/fill/real)
          scale = "fit";
          # Initial image position on the window (center/top/bottom/free/...)
          position = "center";
          # Anti-aliasing mode (none/box/bilinear/bicubic/mks13)
          antialiasing = "mks13";
        };
        gallery = {
          size = 200;
          cache = 100;
          preload = "no";
          pstore = "no"; # Enable/disable storing thumbnails in persistent storage (yes/no)
          fill = "yes";
          antialiasing = "mks13";
          window = gray1 + swayimgOpacity; # Background color of the window (RGBA)
          background = gray2; # Background color of non-selected tiles (RGBA)
          select = white0; # Background color of the selected tile (RGBA)
          border = gray1; # Border color of the selected tile (RGBA)
          shadow = gray1; # Shadow color of the selected tile (RGBA)
        };
        list = {
          order = "alpha";
          reverse = "no";
          recursive = "no"; # Read directories recursively (yes/no)
          all = "no"; # Add files from the same directory as the first file (yes/no)
          fsmon = "yes"; # Enable file system monitoring for adding new images to the list (yes/no)
        };
        font = {
          name = config.custom.fonts.monospace;
          size = 14;
          color = white0;
          shadow = gray1 + swayimgOpacity;
          background = gray1;
        };
        info = {
          show = "yes"; # Show on startup (yes/no)
          info_timeout = 5;
          status_timeout = 3;
        };
        "info.viewer" = {
          # Display scheme for viewer mode (position = content)
          top_left = "+name,+format,+filesize,+imagesize,+exif";
          top_right = "index";
          bottom_left = "scale,frame";
          bottom_right = "status";
        };
        "info.gallery" = {
          # Display scheme for gallery mode (position = content)
          top_left = "none";
          top_right = "none";
          bottom_left = "none";
          bottom_right = "name,status";
        };
        "keys.viewer" = {
          "F1" = "help";
          "Home" = "first_file";
          "End" = "last_file";
          "Prior" = "prev_file";
          "Next" = "next_file";
          "Space" = "next_file";
          "Shift+r" = "rand_file";
          "Shift+d" = "prev_dir";
          "d" = "next_dir";
          "Shift+o" = "prev_frame";
          "o" = "next_frame";
          "c" = "skip_file";
          "s" = "mode slideshow";
          "n" = "animation";
          "f" = "fullscreen";
          "Return" = "mode";
          "Left" = "step_left 10";
          "Right" = "step_right 10";
          "Up" = "step_up 10";
          "Down" = "step_down 10";
          "Equal" = "zoom +10";
          "Plus" = "zoom +10";
          "Minus" = "zoom -10";
          "w" = "zoom width";
          "Shift+w" = "zoom height";
          "z" = "zoom fit";
          "Shift+z" = "zoom fill";
          "0" = "zoom real";
          "BackSpace" = "zoom optimal";
          "Alt+z" = "zoom keep";
          "Alt+s" = "zoom";
          "bracketleft" = "rotate_left";
          "bracketright" = "rotate_right";
          "m" = "flip_vertical";
          "Shift+m" = "flip_horizontal";
          "a" = "antialiasing next";
          "Shift+a" = "antialiasing prev";
          "r" = "reload";
          "i" = "info";
          "Shift+Delete" = "exec rm -f '%' && echo 'File removed: %'; skip_file";
          "Escape" = "exit";
          "q" = "exit";
          # Mouse related
          "ScrollLeft" = "step_right 5";
          "ScrollRight" = "step_left 5";
          "ScrollUp" = "step_up 5";
          "ScrollDown" = "step_down 5";
          "Ctrl+ScrollUp" = "zoom +10";
          "Ctrl+ScrollDown" = "zoom -10";
          "Shift+ScrollUp" = "prev_file";
          "Shift+ScrollDown" = "next_file";
          "Alt+ScrollUp" = "prev_frame";
          "Alt+ScrollDown" = "next_frame";
          "MouseSide" = "prev_file";
          "MouseExtra" = "next_file";
        };
        "keys.slideshow" = {
          "F1" = "help";
          "Home" = "first_file";
          "End" = "last_file";
          "Prior" = "prev_file";
          "Next" = "next_file";
          "Shift+r" = "rand_file";
          "Shift+d" = "prev_dir";
          "d" = "next_dir";
          "Space" = "pause";
          "i" = "info";
          "f" = "fullscreen";
          "Return" = "mode";
          "Escape" = "exit";
          "q" = "exit";
        };
        "keys.gallery" = {
          "F1" = "help";
          "Home" = "first_file";
          "End" = "last_file";
          "Left" = "step_left";
          "Right" = "step_right";
          "Up" = "step_up";
          "Down" = "step_down";
          "Prior" = "page_up";
          "Next" = "page_down";
          "c" = "skip_file";
          "f" = "fullscreen";
          "Return" = "mode";
          "a" = "antialiasing next";
          "Shift+a" = "antialiasing prev";
          "r" = "reload";
          "i" = "info";
          "Shift+Delete" = "exec rm -f '%' && echo 'File removed: %'; skip_file";
          "Escape" = "exit";
          "q" = "exit";
          # Mouse related
          "ScrollLeft" = "step_right";
          "ScrollRight" = "step_left";
          "ScrollUp" = "step_up";
          "ScrollDown" = "step_down";
        };
      };
    };

    niri.settings.window-rules = [
      {
        matches = singleton {
          app-id = "^(swayimg)$";
        };
        open-floating = true;
        default-column-width.proportion = 0.50;
        default-window-height.proportion = 0.50;
        opacity = 1.0;
      }
    ];
  };
  xdg = {
    desktopEntries.swayimg = {
      name = "Swayimg";
      genericName = "Image Viewer";
      icon = "swayimg";
      terminal = false;
      exec = "${getExe pkgs.swayimg}";
    };

    mimeApps.defaultApplications = {
      "image/jpeg" = "swayimg.desktop";
      "image/gif" = "swayimg.desktop";
      "image/webp" = "swayimg.desktop";
      "image/png" = "swayimg.desktop";
    };
  };
}
