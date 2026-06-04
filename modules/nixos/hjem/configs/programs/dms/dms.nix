{lib, ...}: {
  flake.custom.hjemConfigs.dms = {pkgs, ...}: {
    hj = {
      rum.programs.dms = {
        settings = lib.importJSON ./settings.json;

        plugins = {
          settings = {
            dankBatteryAlerts = {
              enabled = true;
            };
            dankKDEConnect = {
              enabled = true;
              selectedDeviceId = "6343c64e7760410ba0e7750fe8a99633";
            };
            dankNotepadModule = {
              enabled = true;
              style = "nordic";
            };
            screenRecorder = {
              enabled = true;
            };
            displayMirror = {
              enabled = true;
              autoRefresh = false;
            };
          };
        };
      };
    };

    # plugin dependencies
    programs.gpu-screen-recorder.enable = true;

    hj.packages = [
      pkgs.wl-mirror
    ];
  };
}
