_: {
  barElevationEnabled = false;
  barConfigs = [
    {
      autoHide = false;
      autoHideDelay = 250;
      borderColor = "surfaceText";
      borderEnabled = false;
      borderOpacity = 1;
      borderThickness = 1;
      bottomGap = 0;
      centerWidgets = [];
      clickActionFollowMouse = false;
      dot = false;
      enabled = true;
      followInterfaceStyle = true;
      fontScale = 1;
      gothCornerRadiusOverride = false;
      gothCornerRadiusValue = 12;
      gothCornersEnabled = false;
      hoverPopouts = false;
      id = "default";
      innerPadding = 4;
      island = true;
      islandHighContrast = false;
      islandHomeLayout = [
        {
          enabled = true;
          id = "weather";
        }
        {
          enabled = true;
          id = "clock";
        }
        {
          enabled = true;
          id = "privacy";
        }
        {
          enabled = true;
          id = "notifications";
        }
        {
          enabled = true;
          id = "status";
        }
        {
          enabled = false;
          id = "workspaces";
        }
        {
          enabled = false;
          id = "media";
        }
        {
          enabled = false;
          id = "volume";
        }
        {
          enabled = false;
          id = "brightness";
        }
        {
          enabled = false;
          id = "tray";
        }
      ];
      islandNotch = true;
      islandPalette = "default";
      islandRouteLauncher = "follow";
      islandWidgetStash = {
        entry = {
          enabled = true;
          id = "island";
          islandBatteryStyle = "duo";
          islandHomeClockDisplay = "both";
          islandHomeCompactTight = false;
          islandHomeLayout = [
            {
              enabled = true;
              id = "weather";
            }
            {
              enabled = true;
              id = "clock";
            }
            {
              enabled = true;
              id = "privacy";
            }
            {
              enabled = true;
              id = "status";
            }
            {
              enabled = true;
              id = "notifications";
            }
            {
              enabled = false;
              id = "workspaces";
            }
            {
              enabled = false;
              id = "media";
            }
            {
              enabled = false;
              id = "volume";
            }
            {
              enabled = false;
              id = "brightness";
            }
            {
              enabled = false;
              id = "tray";
            }
          ];
          islandHomeStatusContent = "battery";
          islandInteractionMode = "click";
          islandRouteMedia = "island";
        };
        index = 0;
        sectionId = "center";
      };
      leftWidgets = [
        {
          enabled = true;
          id = "launcherButton";
          launcherLogoColorOverride = "surface";
          launcherLogoMode = "compositor";
          launcherLogoSizeOffset = 12;
        }
        {
          enabled = true;
          id = "systemTray";
        }
      ];
      name = "Main Bar";
      noBackground = false;
      openOnOverview = false;
      popupGapsAuto = true;
      popupGapsManual = 4;
      position = 0;
      rightWidgets = [
        {
          enabled = true;
          id = "cpuUsage";
        }
        {
          enabled = true;
          id = "memUsage";
          showInGb = true;
        }
        {
          diskUsageMode = 0;
          enabled = true;
          id = "diskUsage";
          mountPath = "/persist";
        }
        {
          enabled = true;
          id = "music";
          mediaStyle = "activity";
        }
        {
          batteryStyle = "icon";
          enabled = true;
          id = "battery";
          showBatteryPercentOnlyOnBattery = true;
          showBatteryPowerCharging = true;
          showBatteryTime = true;
          showBatteryTimeOnlyOnBattery = true;
        }
      ];
      screenPreferences = ["all"];
      showOnLastDisplay = true;
      spacing = 4;
      squareCorners = false;
      transparency = 1;
      visible = true;
      widgetFollowInterfaceStyle = true;
      widgetStyle = "pills";
      widgetTransparency = 1;
    }
    {
      autoHide = false;
      autoHideDelay = 250;
      borderColor = "surfaceText";
      borderEnabled = false;
      borderOpacity = 1;
      borderThickness = 1;
      bottomGap = 0;
      centerWidgets = [
        "music"
        "clock"
        "weather"
      ];
      dot = true;
      enabled = false;
      followInterfaceStyle = false;
      fontScale = 1;
      gothCornerRadiusOverride = false;
      gothCornerRadiusValue = 12;
      gothCornersEnabled = false;
      id = "dot1793361430738";
      innerPadding = 4;
      leftWidgets = [
        "launcherButton"
        "workspaceSwitcher"
        "focusedWindow"
      ];
      name = "Dot";
      noBackground = false;
      openOnOverview = false;
      popupGapsAuto = true;
      popupGapsManual = 4;
      position = 0;
      rightWidgets = [
        "systemTray"
        "clipboard"
        "cpuUsage"
        "memUsage"
        "notificationButton"
        "battery"
        "controlCenterButton"
      ];
      screenPreferences = ["all"];
      showOnLastDisplay = true;
      spacing = 4;
      squareCorners = false;
      transparency = 1;
      visible = true;
      widgetFollowInterfaceStyle = true;
      widgetTransparency = 1;
    }
    {
      attachToScreenEdge = true;
      autoHide = false;
      autoHideDelay = 250;
      barLengthMode = "fit";
      borderColor = "surfaceText";
      borderEnabled = false;
      borderOpacity = 1;
      borderThickness = 1;
      bottomGap = 0;
      centerWidgets = [
        {
          enabled = true;
          id = "quickCapture";
        }
        {
          enabled = true;
          id = "workspaceSwitcher";
          showOccupiedWorkspacesOnly = true;
          showWorkspaceApps = false;
          showWorkspaceIndex = false;
          showWorkspaceName = false;
          showWorkspacePadding = false;
          workspaceFollowFocus = false;
          workspaceIndicatorCompact = false;
          workspaceIndicatorRoundness = -1;
          workspaceIndicatorStyle = "cards";
        }
        {
          enabled = true;
          id = "dankKDEConnect";
        }
      ];
      clickActionFollowMouse = false;
      dot = false;
      enabled = true;
      followInterfaceStyle = true;
      fontScale = 1;
      gothCornerRadiusOverride = false;
      gothCornerRadiusValue = 12;
      gothCornersEnabled = true;
      hideOnLastDisplay = false;
      hoverPopouts = false;
      id = "bar1793415316606";
      innerPadding = 4;
      leftWidgets = [];
      name = "Side Bar";
      noBackground = false;
      openOnOverview = false;
      popupGapsAuto = true;
      popupGapsManual = 4;
      position = 2;
      rightWidgets = [];
      screenPreferences = ["all"];
      showOnLastDisplay = true;
      spacing = 4;
      squareCorners = false;
      transparency = 1;
      visible = true;
      widgetFollowInterfaceStyle = true;
      widgetStyle = "pills";
      widgetTransparency = 1;
    }
  ];
}
