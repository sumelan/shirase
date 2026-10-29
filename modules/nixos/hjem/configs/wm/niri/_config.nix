{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) getExe;
in {
  hotkey-overlay = {
    skip-at-startup = [];
    hide-not-bound = [];
  };

  overview = {
    zoom = 0.500000;
    backdrop-color = "#3B4252";
    workspace-shadow = {color = "#3B4252" + "90";};
  };

  input = {
    focus-follows-mouse = [];

    keyboard = {
      xkb = {layout = "us";};
      repeat-delay = 600;
      repeat-rate = 25;
      track-layout = "global";
    };

    touchpad = {
      tap = [];
      natural-scroll = [];
    };

    tablet = {map-to-output = "DSI-1";};

    touch = {map-to-output = "DSI-1";};
  };

  cursor = {
    xcursor-theme = config.custom.gtk.cursor.name;
    xcursor-size = config.custom.gtk.cursor.size;
    hide-when-typing = [];
    hide-after-inactive-ms = 1000;
  };

  gestures = {
    dnd-edge-view-scroll = {
      trigger-width = 60;
      delay-ms = 100;
      max-speed = 1500;
    };
  };

  layout = {
    center-focused-column = "never";

    always-center-single-column = [];

    empty-workspace-above-first = [];

    default-column-display = "normal";

    background-color = "transparent";

    gaps = 14;

    preset-column-widths._children = [
      {proportion = 0.33333;}
      {proportion = 0.5;}
      {proportion = 0.66667;}
    ];

    default-column-width._children = [
      {proportion = 0.5;}
    ];

    preset-window-heights._children = [
      {proportion = 0.33333;}
      {proportion = 0.5;}
      {proportion = 0.66667;}
    ];

    focus-ring = {
      width = 3;
    };

    border = {off = [];};

    shadow = {
      on = [];
      offset._props = {
        x = 0;
        y = 0;
      };
      softness = 20;
      spread = 10;
      draw-behind-window = false;
    };

    tab-indicator = {
      hide-when-single-tab = true;
      place-within-column = true;
      gap = -15;
      width = 8;
      length = {
        _props.total-proportion = 0.800000;
      };
      position = "right";
      gaps-between-tabs = 0.000000;
      corner-radius = 0.000000;
    };

    struts = {
      left = 2;
      right = 2;
      top = 2;
      bottom = 2;
    };
  };

  spawn-at-startup = [
    []
    []
  ];

  recent-windows = {
    debounce-ms = 750;
    open-delay-ms = 150;
    highlight = {
      padding = 30;
      corner-radius = 10;
    };
    previews = {
      max-height = 480;
      max-scale = 0.5;
    };
    binds = {
      "Mod+Tab" = {next-window = [];};
      "Mod+Shift+Tab" = {previous-window = [];};
      "Mod+grave" = {
        next-window = {
          _props.filter = "app-id";
        };
      };
      "Mod+Shift+grave" = {
        previous-window = {
          _props.filter = "app-id";
        };
      };
    };
  };

  prefer-no-csd = [];

  screenshot-path = "${config.hjem.users.sumelan.directory}/Pictures/Screenshots/screenshot_%Y-%m-%d_%H-%M-%S.png";

  xwayland-satellite = let
    # xwayland
    xwayland =
      if config.custom.wayland.windowManager.niri.xwayland
      then {
        path = getExe pkgs.xwayland-satellite;
      }
      else {
        off = [];
      };
  in
    xwayland;

  clipboard = {disable-primary = [];};

  environment = {
    XDG_CURRENT_DESKTOP = "niri";
  };

  blur = {
    passes = 2;
    offset = 3.0;
    noise = 0.03;
    saturation = 1.0;
  };

  include = [
    [
      {
        _args = ["noctalia.kdl"];
        _props = {
          optional = true;
        };
      }
    ]
  ];

  debug = {
    # Allows notification actions and window activation from Noctalia.
    honor-xdg-activation-with-invalid-serial = [];
  };
}
