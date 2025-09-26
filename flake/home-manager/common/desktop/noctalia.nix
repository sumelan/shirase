{
  lib,
  config,
  pkgs,
  inputs,
  isLaptop,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    getExe
    splitString
    ;

  noctaliaPkgs = inputs.noctalia-shell.packages.${pkgs.system}.default;
in {
  imports = [inputs.noctalia-shell.homeModules.default];

  options.custom = {
    noctalia.enable = mkEnableOption "Noctalia for Niri" // {default = true;};
  };

  config = mkIf config.custom.noctalia.enable {
    home.packages = [noctaliaPkgs];

    programs.noctalia-shell = {
      enable = true;
      # everforest default palette
      colors = {
        mError = "#e67e80";
        mOnError = "#232a2e";
        mOnPrimary = "#232a2e";
        mOnSecondary = "#232a2e";
        mOnSurface = "#859289";
        mOnSurfaceVariant = "#d3c6aa";
        mOnTertiary = "#232a2e";
        mOutline = "#d3c6aa";
        mPrimary = "#d3c6aa";
        mSecondary = "#d3c6aa";
        mShadow = "#475258";
        mSurface = "#232a2e";
        mSurfaceVariant = "#2d353b";
        mTertiary = "#9da9a0";
      };
      settings = {
        appLauncher = {
          backgroundOpacity = 0.85;
          enableClipboardHistory = true;
          pinnedExecs = [];
          position = "center";
          sortByMostUsed = true;
          useApp2Unit = false;
        };
        audio = {
          cavaFrameRate = 60;
          mprisBlacklist = ["librewolf"];
          preferredPlayer = "spotify";
          visualizerType = "linear";
          volumeStep = 5;
        };
        bar = {
          backgroundOpacity = 0.95;
          density = "comfortable";
          floating = false;
          marginHorizontal = 0.25;
          marginVertical = 0.25;
          monitors = [];
          position =
            if isLaptop
            then "left"
            else "center";
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
                id = "ActiveWindow";
                showIcon = true;
              }
              {
                id = "MediaMini";
                showAlbumArt = false;
                showVisualizer = false;
                visualizerType = "linear";
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
                id = "ScreenRecorder";
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
              {
                displayMode = "onhover";
                id = "Volume";
              }
              {
                displayMode = "onhover";
                id = "Brightness";
              }
              {
                displayMode = "alwaysShow";
                id = "Battery";
                warningThreshold = 30;
              }
              {
                formatHorizontal = "HH:mm ddd, MMM dd";
                formatVertical = "HH mm - MM dd";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
            ];
          };
        };
        brightness = {
          brightnessStep = 5;
        };
        colorSchemes = {
          darkMode = true;
          predefinedScheme = "Everforest";
          useWallpaperColors = false;
        };
        dock = {
          autoHide = false;
          backgroundOpacity = 1;
          exclusive = false;
          floatingRatio = 1;
          monitors = [];
          pinnedApps = [];
        };
        general = {
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
          name = "Tokyo";
          showWeekNumberInCalendar = false;
          use12hourFormat = false;
          useFahrenheit = false;
        };
        matugen = {
          enableUserTemplates = false;
          foot = false;
          fuzzel = false;
          ghostty = false;
          gtk3 = false;
          gtk4 = false;
          kitty = false;
          pywalfox = false;
          qt5 = false;
          qt6 = false;
          vesktop = false;
        };
        network = {
          bluetoothEnabled = true;
          wifiEnabled = config.custom.wifi.enable;
        };
        nightLight = {
          autoSchedule = true;
          dayTemp = "6500";
          enabled = true;
          forced = false;
          manualSunrise = "06:30";
          manualSunset = "18:30";
          nightTemp = "4000";
        };
        notifications = {
          alwaysOnTop = false;
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
        settingsVersion = 8;
        ui = {
          fontBillboard = "Inter";
          fontDefault = config.stylix.fonts.sansSerif.name;
          fontFixed = config.stylix.fonts.monospace.name;
          idleInhibitorEnabled = false;
          monitorsScaling = [];
        };
        wallpaper = {
          directory = "${config.xdg.userDirs.pictures}/Wallpapers";
          enableMultiMonitorDirectories = false;
          enabled = true;
          fillColor = config.lib.stylix.colors.withHashtag.base00;
          fillMode = "crop";
          monitors = [
            {
              inherit (config.programs.noctalia-shell.settings.wallpaper) directory;
              name = config.lib.monitors.mainMonitorName;
              wallpaper = "${config.home.homeDirectory}/.defaultWall.jpg";
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
        hotkeyColor = config.lib.stylix.colors.withHashtag.base0D;
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
        "Mod+D" = {
          action.spawn = noctalia "controlCenter toggle";
          hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Sidepanel'';
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
          hotkey-overlay.title = ''<span foreground="${hotkeyColor}">[Noctalia]</span> Powerpanel'';
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
      "noctalia" = {
        Unit = {
          Description = "Noctalia Shell Service";
          After = [config.wayland.systemd.target];
          PartOf = [config.wayland.systemd.target];
        };
        Service = {
          Type = "exec";
          ExecStart = "${getExe noctaliaPkgs}";
          Restart = "on-failure";
          RestartSec = "5s";
          TimeoutStopSec = "5s";
          Environment = [
            "QT_QPA_PLATFORM=wayland"
            "ELECTRON_OZONE_PLATFORM_HINT=auto"
          ];
          Slice = "session.slice";
        };
        Install = {
          WantedBy = [config.wayland.systemd.target];
        };
      };
    };
  };
}
