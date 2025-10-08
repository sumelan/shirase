{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit
    (lib)
    getExe
    splitString
    ;

  inherit
    (config.lib.stylix.colors.withHashtag)
    base00
    base01
    base02
    base06
    base07
    base08
    base0A
    base0B
    base0D
    ;

  noctaliaPkgs = inputs.noctalia-shell.packages.${pkgs.system}.default;
in {
  home.packages = [noctaliaPkgs];

  programs.noctalia-shell = {
    enable = true;
    colors = {
      mError = base08;
      mOnError = base00;
      mOnPrimary = base00;
      mOnSecondary = base00;
      mOnSurface = base07;
      mOnSurfaceVariant = base06;
      mOnTertiary = base00;
      mOutline = base02;
      mPrimary = base0A;
      mSecondary = base0B;
      mShadow = base00;
      mSurface = base00;
      mSurfaceVariant = base01;
      mTertiary = base0D;
    };
    settings = {
      appLauncher = {
        backgroundOpacity = config.stylix.opacity.popups;
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
        ];
        preferredPlayer = "Spotify";
        visualizerType = "linear";
        volumeOverdrive = false;
        volumeStep = 5;
      };
      bar = {
        backgroundOpacity = config.stylix.opacity.desktop;
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
              icon = "";
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              autoHide = true;
              id = "ActiveWindow";
              scrollingMode = "hover";
              showIcon = true;
              width = 145;
            }
            {
              autoHide = true;
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
          right = [
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
            {
              displayMode = "alwaysShow";
              id = "Battery";
              warningThreshold = 20;
            }
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
      brightness = {
        brightnessStep = 5;
      };
      colorSchemes = {
        darkMode =
          if (config.stylix.polarity == "dark")
          then true
          else false;
        generateTemplatesForPredefined = false;
        matugenSchemeType = "scheme-fruit-salad";
        predefinedScheme = "Gruvbox";
        useWallpaperColors = false;
      };
      controlCenter = {
        position = "close_to_bar_button";
      };
      dock = {
        backgroundOpacity = 1;
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
        dimDesktop = true;
        forceBlackScreenCorners = false;
        radiusRatio = 1;
        screenRadiusRatio = 1;
        showScreenCorners = true;
      };
      hooks = {
        darkModeChange = "";
        enabled = false;
        wallpaperChange = "";
      };
      location = {
        name = "Shiga";
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
      settingsVersion = 12;
      templates = {
        enableUserTemplates = false;
        foot = false;
        fuzzel = false;
        ghostty = false;
        gtk = false;
        kitty = false;
        pywalfox = false;
        qt = false;
        vesktop = false;
      };
      ui = {
        fontDefault = config.gtk.font.name;
        fontDefaultScale = 1;
        fontFixed = config.stylix.fonts.monospace.name;
        fontFixedScale = 1;
        idleInhibitorEnabled = false;
        monitorsScaling = [
          {
            name = "eDP-1";
            scale = 1.0;
          }
          {
            name = "DP-1";
            scale = 1.0;
          }
          {
            name = "DSI-1";
            scale = 1.2;
          }
        ];
        tooltipsEnabled = true;
      };
      wallpaper = {
        defaultWallpaper = "";
        directory = "${config.xdg.userDirs.pictures}/Wallpapers";
        enableMultiMonitorDirectories = false;
        enabled = true;
        fillColor = base00;
        fillMode = "crop";
        monitors = [
          {
            inherit (config.programs.noctalia-shell.settings.wallpaper) directory;
            name = config.lib.monitors.mainMonitorName;
            wallpaper = "${config.home.homeDirectory}/.wall.png";
          }
        ];
        randomEnabled = false;
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
      hotkeyColor = base0A;
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
        Slice = "session.slice";
      };
      Install = {
        WantedBy = [config.wayland.systemd.target];
      };
    };
  };
}
