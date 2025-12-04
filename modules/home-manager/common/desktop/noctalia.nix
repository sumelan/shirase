{
  lib,
  config,
  isLaptop,
  ...
}: let
  inherit (lib) optional splitString;
  inherit (lib.custom.colors) black0 magenta_bright;
  inherit (lib.custom.niri) hotkey;
in {
  programs = {
    noctalia-shell = {
      enable = true;
      systemd.enable = true;
      settings = {
        settingsVersion = 26;
        bar = {
          position = "left";
          backgroundOpacity = 0.85;
          monitors = [];
          density = "comfortable";
          showCapsule = true;
          capsuleOpacity = 0.85;
          floating = false;
          marginVertical = 0.25;
          marginHorizontal = 0.25;
          outerCorners = true;
          exclusive = true;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                colorizeDistroLogo = false;
                colorizeSystemIcon = "primary";
                customIconPath = "";
                enableColorization = true;
                icon = "niri";
                useDistroLogo = false;
              }
              {
                id = "SystemMonitor";
                diskPath = "/persist";
                showCpuTemp = true;
                showCpuUsage = true;
                showDiskUsage = false;
                showMemoryAsPercent = false;
                showMemoryUsage = true;
                showNetworkStats = false;
                usePrimaryColor = true;
              }
              {
                id = "ActiveWindow";
                colorizeIcons = true;
                hideMode = "hidden";
                maxWidth = 145;
                scrollingMode = "hover";
                showIcon = true;
                useFixedWidth = false;
              }
              {
                id = "MediaMini";
                hideMode = "hidden";
                hideWhenIdle = false;
                maxWidth = 145;
                scrollingMode = "hover";
                showAlbumArt = true;
                showArtistFirst = true;
                showProgressRing = true;
                showVisualizer = true;
                useFixedWidth = false;
                visualizerType = "wave";
              }
            ];
            center = [
              {
                id = "Workspace";
                characterCount = 2;
                followFocusedScreen = true;
                hideUnoccupied = true;
                labelMode = "none";
              }
            ];
            right =
              [
                {
                  id = "ScreenRecorder";
                }
                {
                  id = "Tray";
                  blacklist = [
                    "nm-applet"
                    "bluetooth*"
                  ];
                  colorizeIcons = false;
                  drawerEnabled = false;
                  pinned = [];
                }
                {
                  id = "NotificationHistory";
                  hideWhenZero = true;
                  showUnreadBadge = true;
                }
              ]
              ++ (optional isLaptop {
                id = "Battery";
                deviceNativePath = "";
                displayMode = "onhover";
                warningThreshold = 20;
              })
              ++ [
                {
                  id = "Volume";
                  displayMode = "onhover";
                }
                {
                  id = "Brightness";
                  displayMode = "onhover";
                }
                {
                  id = "Clock";
                  customFont = "";
                  formatHorizontal = "HH:mm ddd, MMM dd";
                  formatVertical = "MM dd - HH mm";
                  useCustomFont = false;
                  usePrimaryColor = true;
                }
              ];
          };
        };
        general = {
          avatarImage = "${config.home.homeDirectory}/.face";
          dimmerOpacity = 0.6;
          showScreenCorners = true;
          forceBlackScreenCorners = false;
          scaleRatio = 1;
          radiusRatio = 1;
          screenRadiusRatio = 1;
          animationSpeed = 1;
          animationDisabled = false;
          compactLockScreen = false;
          lockOnSuspend = true;
          showHibernateOnLockScreen = false;
          enableShadows = true;
          shadowDirection = "center";
          shadowOffsetX = 0;
          shadowOffsetY = 0;
          language = "";
          allowPanelsOnScreenWithoutBar = true;
        };
        ui = {
          fontDefault = config.custom.fonts.regular;
          fontFixed = config.custom.fonts.monospace;
          fontDefaultScale = 1;
          fontFixedScale = 1;
          tooltipsEnabled = true;
          panelBackgroundOpacity = 0.85;
          panelsAttachedToBar = true;
          settingsPanelAttachToBar = false;
        };
        location = {
          name = "Shiga";
          weatherEnabled = true;
          weatherShowEffects = true;
          useFahrenheit = false;
          use12hourFormat = false;
          showWeekNumberInCalendar = false;
          showCalendarEvents = true;
          showCalendarWeather = true;
          analogClockInCalendar = false;
          firstDayOfWeek = -1;
        };
        calendar = {
          cards = [
            {
              enabled = true;
              id = "calendar-header-card";
            }
            {
              enabled = true;
              id = "calendar-month-card";
            }
            {
              enabled = true;
              id = "timer-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
          ];
        };
        screenRecorder = {
          directory = "${config.xdg.userDirs.videos}/noctalia";
          frameRate = 60;
          audioCodec = "opus";
          videoCodec = "h264";
          quality = "very_high";
          colorRange = "limited";
          showCursor = true;
          audioSource = "default_output";
          videoSource = "portal";
        };
        wallpaper = {
          enabled = true;
          overviewEnabled = true;
          directory = "${config.xdg.userDirs.pictures}/Wallpapers";
          enableMultiMonitorDirectories = false;
          recursiveSearch = true;
          fillMode = "crop";
          fillColor = black0;
          randomEnabled = false;
          randomIntervalSec = 300;
          transitionDuration = 1500;
          transitionType = "random";
          transitionEdgeSmoothness = 0.05;
          panelPosition = "follow_bar";
          hideWallpaperFilenames = true;
          setWallpaperOnAllMonitors = true;
          useWallhaven = false;
          wallhavenQuery = "";
          wallhavenSorting = "relevance";
          wallhavenOrder = "desc";
          wallhavenCategories = "111";
          wallhavenPurity = "100";
          wallhavenResolutionMode = "atleast";
          wallhavenResolutionWidth = "";
          wallhavenResolutionHeight = "";
          monitorDirectories = [];
        };
        appLauncher = {
          enableClipboardHistory = true;
          enableClipPreview = true;
          position = "center";
          pinnedExecs = [];
          useApp2Unit = false;
          sortByMostUsed = true;
          terminalCommand = "foot";
          customLaunchPrefixEnabled = false;
          customLaunchPrefix = "";
          viewMode = "list";
        };
        controlCenter = {
          position = "close_to_bar_button";
          shortcuts = {
            left =
              (optional isLaptop {
                id = "WiFi";
              })
              ++ [
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
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
        };
        systemMonitor = {
          cpuWarningThreshold = 80;
          cpuCriticalThreshold = 90;
          tempWarningThreshold = 80;
          tempCriticalThreshold = 90;
          memWarningThreshold = 80;
          memCriticalThreshold = 90;
          diskWarningThreshold = 80;
          diskCriticalThreshold = 90;
          cpuPollingInterval = 3000;
          tempPollingInterval = 3000;
          memPollingInterval = 3000;
          diskPollingInterval = 3000;
          networkPollingInterval = 3000;
          useCustomColors = true;
          warningColor = "#5e81ac";
          criticalColor = "#bf616a";
        };
        dock = {
          enabled = true;
          displayMode = "auto_hide";
          backgroundOpacity = 0.85;
          radiusRatio = 0.70;
          floatingRatio = 1;
          size = 1.2;
          onlySameOutput = true;
          monitors = [];
          pinnedApps = [];
          colorizeIcons = true;
        };
        network = {
          wifiEnabled =
            if isLaptop
            then true
            else false;
        };
        sessionMenu = {
          enableCountdown = true;
          countdownDuration = 10000;
          position = "center";
          showHeader = true;
          powerOptions = [
            {
              action = "lock";
              countdownEnabled = true;
              enabled = true;
            }
            {
              action = "suspend";
              countdownEnabled = true;
              enabled = true;
            }
            {
              action = "hibernate";
              countdownEnabled = true;
              enabled = false;
            }
            {
              action = "reboot";
              countdownEnabled = true;
              enabled = true;
            }
            {
              action = "logout";
              countdownEnabled = true;
              enabled = true;
            }
            {
              action = "shutdown";
              countdownEnabled = true;
              enabled = true;
            }
          ];
        };
        notifications = {
          enabled = true;
          monitors = [];
          location = "top_right";
          overlayLayer = true;
          backgroundOpacity = 0.9;
          respectExpireTimeout = false;
          lowUrgencyDuration = 3;
          normalUrgencyDuration = 8;
          criticalUrgencyDuration = 15;
          enableKeyboardLayoutToast = true;
        };
        osd = {
          enabled = true;
          location = "bottom";
          autoHideMs = 2000;
          overlayLayer = true;
          backgroundOpacity = 0.9;
          enabledTypes = [
            0
            1
            2
            3
          ];
          monitors = [];
        };
        audio = {
          volumeStep = 5;
          volumeOverdrive = false;
          cavaFrameRate = 30;
          visualizerType = "wave";
          visualizerQuality = "high";
          mprisBlacklist = [
            "io.github.htkhiem.Euphonica"
            "Helium"
          ];
          preferredPlayer = "Music Player Daemon";
          externalMixer = "pwvucontrol";
        };
        brightness = {
          brightnessStep = 5;
          enforceMinimum = false;
          enableDdcSupport =
            if isLaptop
            then false
            else true;
        };
        colorSchemes = {
          useWallpaperColors = false;
          predefinedScheme = "Nord";
          darkMode = true;
          schedulingMode = "off";
          manualSunrise = "06:30";
          manualSunset = "18:30";
          matugenSchemeType = "scheme-fruit-salad";
          generateTemplatesForPredefined = true;
        };
        templates = {
          gtk = false;
          qt = false;
          kcolorscheme = false;
          alacritty = false;
          kitty = false;
          ghostty = false;
          foot = false;
          wezterm = false;
          fuzzel = false;
          discord = false;
          pywalfox = false;
          vicinae = false;
          walker = false;
          code = false;
          spicetify = false;
          telegram = false;
          cava = false;
          emacs = false;
          niri = false;
          enableUserTemplates = false;
        };
        nightLight = {
          enabled = true;
          forced = false;
          autoSchedule = true;
          nightTemp = "4000";
          dayTemp = "6500";
          manualSunrise = "06:30";
          manualSunset = "18:30";
        };
        changelog = {
          lastSeenVersion = "";
        };
        hooks = {
          enabled = false;
          wallpaperChange = "";
          darkModeChange = "";
        };
      };
    };

    niri.settings.binds = let
      noctalia = cmd:
        ["noctalia-shell" "ipc" "call"]
        ++ (splitString " " cmd);
    in {
      "Mod+Space" = {
        action.spawn = noctalia "launcher toggle";
        hotkey-overlay.title = hotkey {
          color = magenta_bright;
          name = "󰏒  Noctalia";
          text = "Launcher";
        };
      };
      "Mod+V" = {
        action.spawn = noctalia "launcher clipboard";
        hotkey-overlay.title = hotkey {
          color = magenta_bright;
          name = "󰏒  Noctalia";
          text = "Clipboard";
        };
      };
      "Mod+W" = {
        action.spawn = noctalia "wallpaper toggle";
        hotkey-overlay.title = hotkey {
          color = magenta_bright;
          name = "󰏒  Noctalia";
          text = "Wallpaper";
        };
      };
      "Mod+N" = {
        action.spawn = noctalia "notifications toggleHistory";
        hotkey-overlay.title = hotkey {
          color = magenta_bright;
          name = "󰏒  Noctalia";
          text = "Notifications History";
        };
      };
      "Mod+Shift+N" = {
        action.spawn = noctalia "notifications clear";
        hotkey-overlay.title = hotkey {
          color = magenta_bright;
          name = "󰏒  Noctalia";
          text = "Clear Notifications";
        };
      };
      "Mod+I" = {
        action.spawn = noctalia "idleInhibitor toggle";
        hotkey-overlay.title = hotkey {
          color = magenta_bright;
          name = "󰏒  Noctalia";
          text = "Prevent idle";
        };
      };
      "Mod+X" = {
        action.spawn = noctalia "sessionMenu toggle";
        hotkey-overlay.title = hotkey {
          color = magenta_bright;
          name = "󰏒  Noctalia";
          text = "Session Menu";
        };
      };
      "Mod+Alt+L" = {
        action.spawn = noctalia "lockScreen lock";
        hotkey-overlay.title = hotkey {
          color = magenta_bright;
          name = "󰏒  Noctalia";
          text = "Lock Screen";
        };
      };
      "Mod+Period" = {
        action.spawn = noctalia "controlCenter toggle";
        hotkey-overlay.title = hotkey {
          color = magenta_bright;
          name = "󰏒  Noctalia";
          text = "Control Center";
        };
      };

      "Mod+Comma" = {
        action.spawn = noctalia "settings toggle";
        hotkey-overlay.title = hotkey {
          color = magenta_bright;
          name = "󰏒  Noctalia";
          text = "Settings";
        };
      };
      "XF86AudioRaiseVolume" = {
        action.spawn = noctalia "volume increase";
      };
      "XF86AudioLowerVolume" = {
        action.spawn = noctalia "volume decrease";
      };
      "XF86AudioMute" = {
        action.spawn = noctalia "volume muteOutput";
      };
      "XF86AudioNext" = {
        action.spawn = noctalia "media next";
      };
      "XF86AudioPlay" = {
        action.spawn = noctalia "media playPause";
      };
      "XF86AudioPrev" = {
        action.spawn = noctalia "media previous";
      };
      "XF86AudioStop" = {
        action.spawn = noctalia "media stop";
      };
      "XF86MonBrightnessUp" = {
        action.spawn = noctalia "brightness increase";
      };
      "XF86MonBrightnessDown" = {
        action.spawn = noctalia "brightness decrease";
      };
    };
  };

  custom.persist = {
    home.cache.directories = [
      ".cache/noctalia"
    ];
  };
}
