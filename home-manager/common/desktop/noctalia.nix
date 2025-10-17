{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit
    (lib)
    optional
    getExe
    splitString
    ;

  noctaliaPkgs = inputs.noctalia-shell.packages.${pkgs.system}.default;
in {
  home = {
    packages = [noctaliaPkgs];
    file.".wall.png".source = ./default.png;
  };

  programs.noctalia-shell = {
    enable = true;
    settings = {
      appLauncher = {
        backgroundOpacity = 0.85;
        enableClipboardHistory = true;
        pinnedExecs = [];
        position = "center";
        sortByMostUsed = true;
        terminalCommand = "foot";
        useApp2Unit = false;
      };
      audio = {
        cavaFrameRate = 60;
        mprisBlacklist = [
          "io.github.htkhiem.Euphonica"
          "Mozilla librewolf"
          "Helium"
        ];
        preferredPlayer = "Spotify";
        visualizerType = "mirrored";
        volumeOverdrive = false;
        volumeStep = 5;
      };
      bar = {
        backgroundOpacity = "0.95";
        density = "comfortable";
        floating = false;
        marginHorizontal = 0.25;
        marginVertical = 0.25;
        monitors = [];
        position = "left";
        showCapsule = true;
        widgets = {
          center = [
            {
              hideUnoccupied = true;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          left = [
            {
              customIconPath = "";
              icon = "niri";
              id = "ControlCenter";
              useDistroLogo = false;
            }
            {
              colorizeIcons = true;
              hideMode = "hidden";
              id = "ActiveWindow";
              scrollingMode = "hover";
              showIcon = true;
              width = 145;
            }
            {
              hideMode = "hidden";
              id = "MediaMini";
              scrollingMode = "hover";
              showAlbumArt = false;
              showVisualizer = false;
              visualizerType = "linear";
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
          right =
            [
              {
                blacklist = [
                  "nm-applet"
                  "Fcitx*"
                  "bluetooth*"
                ];
                colorizeIcons = true;
                id = "Tray";
              }
              {
                hideWhenZero = true;
                id = "NotificationHistory";
                showUnreadBadge = true;
              }
              {
                id = "WiFi";
              }
              {
                id = "Bluetooth";
              }
            ]
            ++ (optional config.custom.battery.enable {
              displayMode = "alwaysShow";
              id = "Battery";
              warningThreshold = 20;
            })
            ++ [
              {
                customFont = "";
                formatHorizontal = "HH:mm ddd, MMM dd";
                formatVertical = "HH mm - MM dd";
                id = "Clock";
                useCustomFont = false;
                usePrimaryColor = true;
              }
            ];
        };
      };
      battery = {
        chargingMode = 0;
      };
      brightness = {
        brightnessStep = 5;
      };
      colorSchemes = {
        darkMode = true;
        generateTemplatesForPredefined = false;
        matugenSchemeType = "scheme-fruit-salad";
        predefinedScheme = "Eldritch";
        useWallpaperColors = false;
      };
      controlCenter = {
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = false;
            id = "audio-card";
          }
          {
            enabled = false;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "ScreenRecorder";
            }
            {
              id = "WallpaperSelector";
            }
          ];
          right = [
            {
              id = "Notifications";
            }
            {
              id = "PowerProfile";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "NightLight";
            }
          ];
        };
      };
      dock = {
        backgroundOpacity = 0.85;
        colorizeIcons = true;
        displayMode = "always_visible";
        floatingRatio = 1;
        monitors = [];
        onlySameOutput = true;
        pinnedApps = [];
      };
      general = {
        animationDisabled = false;
        animationSpeed = 1;
        avatarImage = "${config.home.homeDirectory}/.face";
        compactLockScreen = true;
        dimDesktop = true;
        forceBlackScreenCorners = false;
        radiusRatio = 1;
        scaleRatio = 1;
        screenRadiusRatio = 1;
        showScreenCorners = true;
      };
      hooks = {
        darkModeChange = "";
        enabled = false;
        wallpaperChange = "";
      };
      location = {
        name = "Otsu";
        showWeekNumberInCalendar = false;
        use12hourFormat = false;
        useFahrenheit = false;
      };
      network = {
        wifiEnabled = config.custom.wifi.enable;
      };
      nightLight = {
        autoSchedule = true;
        dayTemp = "6500";
        enabled = false;
        forced = false;
        manualSunrise = "06:30";
        manualSunset = "18:30";
        nightTemp = "4000";
      };
      notifications = {
        alwaysOnTop = true;
        criticalUrgencyDuration = 15;
        doNotDisturb = false;
        lastSeenTs = 0;
        location = "top_right";
        lowUrgencyDuration = 3;
        monitors = [];
        normalUrgencyDuration = 8;
        respectExpireTimeout = true;
      };
      osd = {
        alwaysOnTop = true;
        autoHideMs = 2000;
        enabled = true;
        location = "bottom";
        monitors = [];
      };
      screenRecorder = {
        audioCodec = "opus";
        audioSource = "default_output";
        colorRange = "limited";
        directory = config.xdg.userDirs.videos;
        frameRate = 60;
        quality = "very_high";
        showCursor = true;
        videoCodec = "h264";
        videoSource = "portal";
      };
      settingsVersion = 16;
      setupCompleted = true;
      templates = {
        discord = false;
        discord_armcord = false;
        discord_dorion = false;
        discord_equibop = false;
        discord_lightcord = false;
        discord_vesktop = true;
        discord_webcord = false;
        enableUserTemplates = false;
        foot = false;
        fuzzel = false;
        ghostty = false;
        gtk = false;
        kcolorscheme = false;
        kitty = false;
        pywalfox = false;
        qt = false;
      };
      ui = {
        fontDefault = config.gtk.font.name;
        fontDefaultScale = 1;
        fontFixed = config.custom.fonts.monospace;
        fontFixedScale = 1;
        idleInhibitorEnabled = false;
        tooltipsEnabled = true;
      };
      wallpaper = {
        defaultWallpaper = "${config.home.homeDirectory}/.wall.png";
        directory = "${config.xdg.userDirs.pictures}/Wallpapers";
        enableMultiMonitorDirectories = false;
        enabled = true;
        fillColor = "#212337";
        fillMode = "crop";
        monitors = [
          {
            inherit (config.programs.noctalia-shell.settings.wallpaper) directory;
            name = config.lib.monitors.mainMonitorName;
            wallpaper = "";
          }
        ];
        randomEnabled = true;
        randomIntervalSec = 900;
        setWallpaperOnAllMonitors = true;
        transitionDuration = 1500;
        transitionEdgeSmoothness = 0.05;
        transitionType = "random";
      };
    };
  };

  programs.niri.settings = {
    layer-rules = [
      {
        matches = [{namespace = "^swww-daemon$";}];
        place-within-backdrop = true;
      }
      {
        matches = [{namespace = "^quickshell-wallpaper$";}];
      }
      {
        matches = [{namespace = "^quickshell-overview$";}];
        place-within-backdrop = true;
      }
    ];
    binds = let
      noctalia = cmd:
        [
          "${getExe noctaliaPkgs}"
          "ipc"
          "call"
        ]
        ++ (splitString " " cmd);
      hotkeyColor = "#04d1f9";
    in {
      "Mod+Space" = {
        action.spawn = noctalia "launcher toggle";
        hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Launcher'';
      };
      "Mod+V" = {
        action.spawn = noctalia "launcher clipboard";
        hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Clipboard'';
      };
      "Mod+N" = {
        action.spawn = noctalia "notifications toggleHistory";
        hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Notification Histories'';
      };
      "Mod+Shift+N" = {
        action.spawn = noctalia "notifications clear";
        hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Clear Notifications'';
      };
      "Mod+D" = {
        action.spawn = noctalia "controlCenter toggle";
        hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Control Center'';
      };
      "Mod+Comma" = {
        action.spawn = noctalia "settings toggle";
        hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Settings'';
      };
      "Mod+Alt+L" = {
        allow-when-locked = true;
        action.spawn = noctalia "lockScreen toggle";
        hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Lock Screen'';
      };
      "Mod+I" = {
        action.spawn = noctalia "idleInhibitor toggle";
        hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Toggle Idleinhibitor'';
      };
      "Mod+X" = {
        action.spawn = noctalia "sessionMenu toggle";
        hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Session Menu'';
      };
      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn = noctalia "volume increase";
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn = noctalia "volume decrease";
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn = noctalia "volume muteOutput";
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action.spawn = noctalia "volume muteInput";
      };
      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = noctalia "brightness increase";
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = noctalia "brightness decrease";
      };
    };
  };

  systemd.user.services = {
    "noctalia-shell" = {
      Unit = {
        Description = "Noctalia Shell - Wayland desktop shell";
        After = [config.wayland.systemd.target];
        PartOf = [config.wayland.systemd.target];
        StartLimitIntervalSec = 60;
        StartLimitBurst = 3;
      };
      Service = {
        Type = "exec";
        ExecStart = "${getExe noctaliaPkgs}";
        Restart = "on-failure";
        RestartSec = 3;
        TimeoutStartSec = 10;
        TimeoutStopSec = 5;
        Environment = [
          "QT_QPA_PLATFORM=wayland"
          "ELECTRON_OZONE_PLATFORM_HINT=auto"
          "NOCTALIA_SETTINGS_FALLBACK=%h/.config/noctalia/gui-settings.json"
        ];
      };
      Install = {
        WantedBy = [config.wayland.systemd.target];
      };
    };
  };
}
