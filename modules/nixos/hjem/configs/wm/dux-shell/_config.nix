{config}: {
  acLockTimeout = 300;
  acMonitorTimeout = 0;
  acPostLockMonitorTimeout = 600;
  acSuspendTimeout = 1200;
  appDrawerSectionViewModes = {apps = "list";};
  batteryNotifyLow = true;
  blurBorderEnabled = true;
  blurBorderOpacity = 0.35;
  blurBorderSeeded = true;
  blurEnabled = true;
  blurLayerOutlineOpacity = 0;
  blurStrength = 0;
  blurWallpaperOnOverview = false;
  blurredWallpaperLayer = true;
  builtInPluginSettings = {
    dms_clipboard_search = {trigger = "cb";};
    dms_power = {trigger = "pw";};
    dms_qr_generator = {trigger = "qrg";};
    dms_settings_search = {trigger = "?";};
  };
  centeringMode = "index";
  configVersion = 42;
  connectedFrameBarStyleBackups = {};
  controlCenterWidgets = [
    {
      enabled = true;
      h = 1;
      id = "user";
      w = 5;
    }
    {
      enabled = true;
      h = 1;
      id = "settings";
      small = true;
      w = 1;
    }
    {
      enabled = true;
      h = 1;
      id = "lock";
      small = true;
      w = 1;
    }
    {
      enabled = true;
      h = 1;
      id = "power";
      small = true;
      w = 1;
    }
    {
      deviceName = "software:DP-1";
      enabled = true;
      h = 1;
      id = "brightnessSlider";
      w = 4;
    }
    {
      enabled = true;
      h = 1;
      id = "volumeSlider";
      w = 4;
    }
    {
      enabled = true;
      h = 1;
      id = "wifi";
      w = 4;
    }
    {
      enabled = true;
      h = 1;
      id = "bluetooth";
      w = 4;
    }
    {
      enabled = true;
      h = 1;
      id = "audioOutput";
      w = 4;
    }
    {
      enabled = true;
      h = 1;
      id = "audioInput";
      w = 4;
    }
    {
      enabled = true;
      h = 1;
      id = "darkMode";
      w = 2;
    }
    {
      enabled = true;
      h = 1;
      id = "nightMode";
      w = 2;
    }
    {
      enabled = true;
      h = 1;
      id = "doNotDisturb";
      w = 2;
    }
    {
      enabled = true;
      h = 1;
      id = "idleInhibitor";
      w = 2;
    }
    {
      enabled = true;
      h = 1;
      id = "battery";
      w = 4;
    }
    {
      enabled = true;
      h = 1;
      id = "diskUsage";
      mountPath = "/persist";
      w = 4;
    }
    {
      enabled = true;
      h = 1;
      id = "runningApps";
      small = true;
      w = 7;
    }
    {
      enabled = true;
      h = 1;
      id = "edit";
      small = true;
      w = 1;
    }
  ];
  currentThemeCategory = "registry";
  currentThemeName = "custom";
  customThemeFile = "/home/sumelan/.config/dms/themes/catppuccin/theme.json";
  dashTabs = [
    {
      enabled = true;
      id = "overview";
    }
    {
      enabled = true;
      id = "media";
    }
    {
      enabled = true;
      id = "wallpaper";
    }
    {
      enabled = true;
      id = "weather";
    }
    {
      enabled = false;
      id = "wellbeing";
    }
    {
      enabled = false;
      id = "notifications";
    }
  ];
  dashOptions = {
    media = {
      animatedArt = true;
    };
  };
  displayFontFamily = config.custom.fonts.regular;
  dmsWindowsFloatingSeeded = ["niri"];
  dockConfigs = [
    {
      autoHide = false;
      borderColor = "surfaceText";
      borderEnabled = false;
      borderOpacity = 1;
      borderThickness = 1;
      bottomGap = 0;
      editOnRightClick = false;
      enabled = false;
      followInterfaceStyle = true;
      groupByApp = false;
      iconSize = 40;
      id = "dock";
      indicatorStyle = "circle";
      isolateDisplays = false;
      itemSpacing = 4;
      launcherEnabled = false;
      launcherLogoBrightness = 0.5;
      launcherLogoColorOverride = "";
      launcherLogoContrast = 1;
      launcherLogoCustomPath = "";
      launcherLogoMode = "apps";
      launcherLogoSizeOffset = 0;
      magnification = false;
      magnificationExpand = false;
      magnificationProfile = "parabolic";
      magnificationScale = 130;
      margin = 0;
      maxVisibleApps = 0;
      maxVisibleRunningApps = 0;
      mode = "compact";
      name = "Dock";
      openOnOverview = false;
      order = [];
      position = 1;
      restoreSpecialWorkspaceOnClick = false;
      screenPreferences = ["all"];
      separatePinnedAndRunningApps = false;
      showOnFullscreen = false;
      showOnLastDisplay = true;
      showOverflowBadge = true;
      showTrash = false;
      smartAutoHide = false;
      spacing = 4;
      taskbarAlign = "center";
      transparency = 1;
      trashCustomCommand = "";
      trashFileManager = "default";
      useOverlayLayer = false;
      widgetExpansion = "popout";
      widgets = [
        {
          enabled = true;
          id = "dock_launcher";
          widgetId = "dockLauncher";
        }
        {
          enabled = true;
          id = "dock_apps";
          widgetId = "appsDock";
        }
        {
          enabled = true;
          id = "dock_trash";
          widgetId = "dockTrash";
        }
      ];
    }
  ];
  floatingWindowSyncGlobal = true;
  focusRingEnabled = true;
  fontFamily = config.custom.fonts.regular;
  foregroundLayerTransparency = 0.9;
  frameCloseGaps = true;
  frameEnabled = false;
  frameLauncherArcExtender = false;
  frameLauncherEdgeHover = false;
  frameMode = "connected";
  frameShowOnOverview = true;
  hostSurfaceColor = "default";
  launcherStyle = "spotlight";
  monoFontFamily = config.custom.fonts.monospace;
  niriLayoutBorderSize = -1;
  niriLayoutGapsOverride = -1;
  niriOverviewLauncherStyle = "spotlight";
  notificationFocusedMonitor = false;
  notificationOverlayEnabled = false;
  popupTransparency = 0.65;
  powerMenuGridLayout = false;
  radiusMode = "scale";
  radiusStrength = 50;
  registryThemeVariants = {
    catppuccin = {
      dark = {
        accent = "pink";
        flavor = "frappe";
      };
    };
  };
  springBounce = 1;
  systemTrayIconTintMode = "none";
  textRenderQuality = 0;
  textRenderType = 0;
  useAutoLocation = true;
}
