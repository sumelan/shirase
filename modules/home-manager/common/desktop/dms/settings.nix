{
  lib,
  config,
  isLaptop,
  ...
}: let
  inherit (lib.custom.colors) black0;
in {
  programs.dankMaterialShell = {
    default = {
      settings = {
        currentThemeName = "dynamic";
        customThemeFile = "";
        matugenScheme = "scheme-tonal-spot";
        runUserMatugenTemplates = true;
        matugenTargetMonitor = "";
        popupTransparency = 0.85;
        dockTransparency = 0.85;
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
            id = "audioInput";
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
        acSuspendTimeout =
          if isLaptop
          then (60 * 15)
          else 0;
        acSuspendBehavior = 0;
        acProfileName = "";
        batteryMonitorTimeout = 60 * 5;
        batteryLockTimeout = 60 * 3;
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
        dockPosition = 1;
        dockSpacing = 8;
        dockBottomGap = 0;
        dockMargin = 100;
        dockIconSize = 48;
        dockIndicatorStyle = "line";
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
                id = "privacyIndicator";
                enabled = true;
              }
              {
                id = "idleInhibitor";
                enabled = true;
              }
            ];
            centerWidgets = [
              {
                id = "workspaceSwitcher";
                enabled = true;
              }
            ];
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

      session = {
        isLightMode = false;
        wallpaperPath = "${config.xdg.userDirs.pictures}/Wallpapers";
        perMonitorWallpaper = false;
        monitorWallpapers = {};
        perModeWallpaper = false;
        wallpaperPathLight = "";
        wallpaperPathDark = "";
        monitorWallpapersLight = {};
        monitorWallpapersDark = {};
        brightnessExponentialDevices = {};
        brightnessUserSetValues = {};
        brightnessExponentValues = {};
        doNotDisturb = false;
        nightModeEnabled = false;
        nightModeTemperature = 4500;
        nightModeHighTemperature = 6500;
        nightModeAutoEnabled = true;
        nightModeAutoMode = "location";
        nightModeStartHour = 18;
        nightModeStartMinute = 0;
        nightModeEndHour = 6;
        nightModeEndMinute = 0;
        latitude = 0;
        longitude = 0;
        nightModeUseIPLocation = true;
        nightModeLocationProvider = "";
        pinnedApps = [];
        hiddenTrayIds = [
          "nm-applet"
          "blueman"
          "Fcitx"
        ];
        selectedGpuIndex = 0;
        nvidiaGpuTempEnabled = false;
        nonNvidiaGpuTempEnabled = false;
        enabledGpuPciIds = [];
        wifiDeviceOverride = "";
        weatherHourlyDetailed = true;
        wallpaperCyclingEnabled = false;
        wallpaperCyclingMode = "interval";
        wallpaperCyclingInterval = 300;
        wallpaperCyclingTime = "06:00";
        monitorCyclingSettings = {};
        lastBrightnessDevice = "";
        launchPrefix = "";
        wallpaperTransition = "random";
        includedTransitions = [
          "fade"
          "wipe"
          "disc"
          "stripes"
          "iris bloom"
          "pixelate"
          "portal"
        ];
        recentColors = [];
        showThirdPartyPlugins = false;
        configVersion = 1;
      };
    };
  };
}
