{
  lib,
  config,
  pkgs,
  user,
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
      colors = {
        mError = "#bf616a";
        mOnError = "#2e3440";
        mOnPrimary = "#2e3440";
        mOnSecondary = "#2e3440";
        mOnSurface = "#d8dee9";
        mOnSurfaceVariant = "#e5e9f0";
        mOnTertiary = "#2e3440";
        mOutline = "#505a70";
        mPrimary = "#8fbcbb";
        mSecondary = "#88c0d0";
        mShadow = "#2e3440";
        mSurface = "#2e3440";
        mSurfaceVariant = "#3b4252";
        mTertiary = "#5e81ac";
      };
      settings = {
        appLauncher = {
          backgroundOpacity = 0.85;
          enableClipboardHistory = true;
          pinnedExecs = [];
          position = "center";
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
          backgroundOpacity = 0.9;
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
                id = "SidePanelToggle";
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
                id = "NightLight";
              }
              {
                id = "KeepAwake";
              }
            ];
            right = [
              {
                id = "ScreenRecorderIndicator";
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
                alwaysShowPercentage = false;
                displayMode = "onhover";
                id = "Battery";
                warningThreshold = 30;
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
                displayFormat = "time-date-short";
                id = "Clock";
              }
            ];
          };
        };
        brightness = {
          brightnessStep = 5;
        };
        colorSchemes = {
          darkMode = true;
          predefinedScheme = "Nord";
          useWallpaperColors = false;
        };
        dock = {
          autoHide = false;
          backgroundOpacity = 0.8;
          exclusive = false;
          floatingRatio = 0.5;
          monitors = [];
        };
        general = {
          animationSpeed = 1;
          avatarImage = "/home/${user}/.face";
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
          monthBeforeDay = false;
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
          criticalUrgencyDuration = 15;
          doNotDisturb = false;
          lastSeenTs = 0;
          lowUrgencyDuration = 3;
          monitors = [];
          normalUrgencyDuration = 8;
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
        settingsVersion = 3;
        ui = {
          fontBillboard = "Roboto";
          fontDefault = config.stylix.fonts.sansSerif;
          fontFixed = config.stylix.fonts.monospace;
          idleInhibitorEnabled = false;
          monitorsScaling = [];
        };
        wallpaper = {
          directory = "${config.xdg.userDirs.pictures}/Wallpapers";
          enableMultiMonitorDirectories = false;
          enabled = true;
          fillColor = config.lib.stylix.colors.withHashtag.base00;
          fillMode = "crop";
          monitors = [];
          randomEnabled = true;
          randomIntervalSec = 300;
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
          action.spawn = noctalia "sidePanel toggle";
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
          action.spawn = noctalia "powerPanel toggle";
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
