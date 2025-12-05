{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) singleton splitString;
  inherit (lib.custom.colors) black0 green_bright;
  inherit (lib.custom.niri) hotkey;
  jsonFormat = pkgs.formats.json {};
in {
  programs = {
    niri.settings = {
      binds = let
        dms-ipc = cmd:
          ["dms" "ipc" "call"] ++ (splitString " " cmd);
      in {
        "Mod+Space" = {
          action.spawn = dms-ipc "spotlight toggle";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Launcher";
          };
        };
        "Mod+D" = {
          action.spawn = dms-ipc "dash toggle overview";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Dashboard";
          };
        };
        "Mod+W" = {
          action.spawn = dms-ipc "dankdash wallpaper";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Wallpapers";
          };
        };
        "Mod+N" = {
          action.spawn = dms-ipc "notifications toggle";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Notifications";
          };
        };
        "Mod+Comma" = {
          action.spawn = dms-ipc "settings toggle";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Settings";
          };
        };
        "Mod+P" = {
          action.spawn = dms-ipc "notepad toggle";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Notepad";
          };
        };
        "Mod+Alt+L" = {
          action.spawn = dms-ipc "lock lock";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Lock Screen";
          };
        };
        "Mod+X" = {
          action.spawn = dms-ipc "powermenu toggle";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Power Menu";
          };
        };
        "Mod+I" = {
          action.spawn = dms-ipc "inhibit toggle";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Idle Inhibitor";
          };
        };
        "Mod+Alt+N" = {
          action.spawn = dms-ipc "night toggle";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Night Mode";
          };
        };
        "Mod+M" = {
          action.spawn = dms-ipc "processlist toggle";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Processlist";
          };
        };
        "Mod+Y" = {
          action.spawn = dms-ipc "clipboard toggle";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Clipboard";
          };
        };
        "Mod+Backslash" = {
          action.spawn = dms-ipc "niri screenshot";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Interactive Screen-capture";
          };
        };
        "Mod+Shift+Backslash" = {
          action.spawn = dms-ipc "niri screenshotScreen";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Capture entire screen";
          };
        };
        "Mod+Alt+Backslash" = {
          action.spawn = dms-ipc "niri screenshotWindow";
          hotkey-overlay.title = hotkey {
            color = green_bright;
            name = "DankMaterialShell";
            text = "Capture focused window";
          };
        };
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "audio increment 3";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "audio decrement 3";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "audio mute";
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "audio micmute";
        };
        "XF86AudioPlay" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "mpris playPause";
        };
        "XF86AudioNext" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "mpris next";
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "mpris previous";
        };
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "brightness increment 5 ";
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn = dms-ipc "brightness decrement 5 ";
        };
      };
      layer-rules = [
        {
          matches = singleton {
            namespace = "^dms:blurwallpaper$";
          };
          place-within-backdrop = true;
        }
      ];
      environment = {
        DMS_SCREENSHOT_EDITOR = "satty";
      };
    };
  };

  xdg.configFile = {
    "DankMaterialShell/settings.json" = {
      source = jsonFormat.generate "settings" {
        currentThemeName = "dynamic";
        customThemeFile = "";
        matugenScheme = "scheme-tonal-spot";
        runUserMatugenTemplates = true;
        matugenTargetMonitor = "";
        popupTransparency = 0.85;
        dockTransparency = 1;
        widgetBackgroundColor = "sch";
        widgetColorMode = "default";
        cornerRadius = 12;
        use24HourClock = true;
        showSeconds = false;
        useFahrenheit = false;
        nightModeEnabled = true;
        animationSpeed = 1;
        customAnimationDuration = 500;
        wallpaperFillMode = "Fill";
        blurredWallpaperLayer = true;
        blurWallpaperOnOverview = true;
        showLauncherButton = true;
        showWorkspaceSwitcher = true;
        showFocusedWindow = true;
        showWeather = true;
        showMusic = true;
        showClipboard = true;
        showCpuUsage = true;
        showMemUsage = true;
        showCpuTemp = true;
        showGpuTemp = true;
        selectedGpuIndex = 0;
        enabledGpuPciIds = [];
        showSystemTray = true;
        showClock = true;
        showNotificationButton = true;
        showBattery = true;
        showControlCenterButton = true;
        showCapsLockIndicator = true;
        controlCenterShowNetworkIcon = true;
        controlCenterShowBluetoothIcon = true;
        controlCenterShowAudioIcon = true;
        controlCenterShowVpnIcon = false;
        controlCenterShowBrightnessIcon = false;
        controlCenterShowMicIcon = false;
        controlCenterShowBatteryIcon = false;
        controlCenterShowPrinterIcon = false;
        showPrivacyButton = true;
        privacyShowMicIcon = false;
        privacyShowCameraIcon = false;
        privacyShowScreenShareIcon = false;
        controlCenterWidgets = [
          {
            id = "volumeSlider";
            enabled = true;
            width = 50;
          }
          {
            id = "brightnessSlider";
            enabled = true;
            width = 50;
          }
          {
            id = "wifi";
            enabled = true;
            width = 50;
          }
          {
            id = "bluetooth";
            enabled = true;
            width = 50;
          }
          {
            id = "audioOutput";
            enabled = true;
            width = 50;
          }
          {
            id = "idleInhibitor";
            enabled = true;
            width = 50;
          }
          {
            id = "diskUsage";
            enabled = true;
            width = 100;
            instanceId = "mit3bt3ltjiai9vqgkhkekkqc5cc2";
            mountPath = "/persist";
          }
        ];
        showWorkspaceIndex = false;
        showWorkspacePadding = false;
        workspaceScrolling = false;
        showWorkspaceApps = true;
        maxWorkspaceIcons = 6;
        workspacesPerMonitor = true;
        showOccupiedWorkspacesOnly = true;
        dwlShowAllTags = false;
        workspaceNameIcons = {};
        waveProgressEnabled = true;
        scrollTitleEnabled = true;
        clockCompactMode = false;
        focusedWindowCompactMode = false;
        runningAppsCompactMode = true;
        keyboardLayoutNameCompactMode = false;
        runningAppsCurrentWorkspace = true;
        runningAppsGroupByApp = true;
        centeringMode = "index";
        clockDateFormat = "M/d";
        lockDateFormat = "";
        mediaSize = 1;
        appLauncherViewMode = "grid";
        spotlightModalViewMode = "grid";
        sortAppsAlphabetically = false;
        appLauncherGridColumns = 4;
        spotlightCloseNiriOverview = true;
        niriOverviewOverlayEnabled = true;
        weatherLocation = "New York, NY";
        weatherCoordinates = "40.7128,-74.0060";
        useAutoLocation = true;
        weatherEnabled = true;
        networkPreference = "auto";
        vpnLastConnected = "";
        iconTheme = "System Default";
        launcherLogoMode = "compositor";
        launcherLogoCustomPath = "";
        launcherLogoColorOverride = "primary";
        launcherLogoColorInvertOnMode = false;
        launcherLogoBrightness = 0.5;
        launcherLogoContrast = 1;
        launcherLogoSizeOffset = 0;
        fontFamily = config.custom.fonts.regular;
        monoFontFamily = config.custom.fonts.monospace;
        fontWeight = 400;
        fontScale = 1;
        notepadUseMonospace = true;
        notepadFontFamily = "";
        notepadFontSize = 14;
        notepadShowLineNumbers = false;
        notepadTransparencyOverride = -1;
        notepadLastCustomTransparency = 0.7;
        soundsEnabled = true;
        useSystemSoundTheme = false;
        soundNewNotification = true;
        soundVolumeChanged = true;
        soundPluggedIn = true;
        acMonitorTimeout = 60 * 10;
        acLockTimeout = 60 * 5;
        acSuspendTimeout = 60 * 15;
        acSuspendBehavior = 0;
        acProfileName = "";
        batteryMonitorTimeout = 60 * 8;
        batteryLockTimeout = 60 * 5;
        batterySuspendTimeout = 60 * 10;
        batterySuspendBehavior = 0;
        batteryProfileName = "";
        lockBeforeSuspend = true;
        preventIdleForMedia = false;
        loginctlLockIntegration = true;
        fadeToLockEnabled = true;
        fadeToLockGracePeriod = 5;
        launchPrefix = "";
        brightnessDevicePins = {};
        wifiNetworkPins = {};
        bluetoothDevicePins = {};
        audioInputDevicePins = {};
        audioOutputDevicePins = {};
        gtkThemingEnabled = false;
        qtThemingEnabled = false;
        syncModeWithPortal = true;
        terminalsAlwaysDark = false;
        showDock = false;
        dockAutoHide = false;
        dockGroupByApp = true;
        dockOpenOnOverview = false;
        dockPosition = 3;
        dockSpacing = 8;
        dockBottomGap = 0;
        dockMargin = 0;
        dockIconSize = 40;
        dockIndicatorStyle = "circle";
        dockBorderEnabled = false;
        dockBorderColor = "surfaceText";
        dockBorderOpacity = 1;
        dockBorderThickness = 1;
        notificationOverlayEnabled = true;
        modalDarkenBackground = true;
        lockScreenShowPowerActions = true;
        enableFprint = false;
        maxFprintTries = 3;
        lockScreenActiveMonitor = "all";
        lockScreenInactiveColor = black0;
        hideBrightnessSlider = false;
        notificationTimeoutLow = 3000;
        notificationTimeoutNormal = 5000;
        notificationTimeoutCritical = 0;
        notificationPopupPosition = 0;
        osdAlwaysShowValue = true;
        osdPosition = 5;
        osdVolumeEnabled = true;
        osdMediaVolumeEnabled = true;
        osdBrightnessEnabled = true;
        osdIdleInhibitorEnabled = true;
        osdMicMuteEnabled = true;
        osdCapsLockEnabled = true;
        osdPowerProfileEnabled = true;
        osdAudioOutputEnabled = true;
        powerActionConfirm = true;
        powerActionHoldDuration = 1;
        powerMenuActions = [
          "reboot"
          "logout"
          "poweroff"
          "lock"
          "suspend"
          "restart"
        ];
        powerMenuDefaultAction = "logout";
        powerMenuGridLayout = false;
        customPowerActionLock = "";
        customPowerActionLogout = "";
        customPowerActionSuspend = "";
        customPowerActionHibernate = "";
        customPowerActionReboot = "";
        customPowerActionPowerOff = "";
        updaterUseCustomCommand = false;
        updaterCustomCommand = "";
        updaterTerminalAdditionalParams = "";
        displayNameMode = "system";
        screenPreferences = {};
        showOnLastDisplay = {};
        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = 2;
            screenPreferences = ["all"];
            showOnLastDisplay = true;
            leftWidgets = [
              {
                id = "launcherButton";
                enabled = true;
              }
              {
                id = "focusedWindow";
                enabled = true;
              }
              {
                id = "music";
                enabled = true;
                mediaSize = 2;
              }
              {
                id = "workspaceSwitcher";
                enabled = true;
              }
            ];
            centerWidgets = [];
            rightWidgets = [
              {
                id = "systemTray";
                enabled = true;
              }
              {
                id = "notificationButton";
                enabled = true;
              }
              {
                id = "controlCenterButton";
                enabled = true;
              }
              {
                id = "battery";
                enabled = true;
              }
              {
                id = "clock";
                enabled = true;
              }
            ];
            spacing = 4;
            innerPadding = 20;
            bottomGap = 0;
            transparency = 0.7;
            widgetTransparency = 0.75;
            squareCorners = false;
            noBackground = false;
            gothCornersEnabled = false;
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = 12;
            borderEnabled = false;
            borderColor = "surfaceText";
            borderOpacity = 1;
            borderThickness = 1;
            widgetOutlineEnabled = false;
            widgetOutlineColor = "primary";
            widgetOutlineOpacity = 1;
            widgetOutlineThickness = 1;
            fontScale = 1;
            autoHide = false;
            autoHideDelay = 250;
            openOnOverview = true;
            visible = false;
            popupGapsAuto = true;
            popupGapsManual = 4;
            maximizeDetection = true;
          }
        ];
        configVersion = 2;
      };
    };
  };

  custom.persist = {
    home = {
      directories = [
        ".local/state/DankMaterialShell"
      ];
      cache.directories = [
        ".cache/DankMaterialShell"
      ];
    };
  };
}
