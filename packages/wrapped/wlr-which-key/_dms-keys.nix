{key, ...}: [
  {
    key = key;
    desc = "DankMaterialShell ipc keys.";
    submenu = [
      {
        key = "c";
        desc = "Popup control-center.";
        cmd =
          # sh
          ''dms ipc control-center toggle'';
      }
      {
        key = "d";
        desc = "Popup dashboard with multiple tabs.";
        submenu = [
          {
            key = "o";
            desc = "Toggle Overview tab.";
            cmd =
              # sh
              ''dms ipc dash toggle overview'';
          }
          {
            key = "m";
            desc = "Toggle Media tab.";
            cmd =
              # sh
              ''dms ipc dash toggle media'';
          }
          {
            key = "w";
            desc = "Toggle Wallpaper tab.";
            cmd =
              # sh
              ''dms ipc dash toggle wallpaper'';
          }
        ];
      }
      {
        key = "n";
        desc = "Toggle notepad.";
        cmd =
          # sh
          ''dms ipc notepad toggle'';
      }
      {
        key = "p";
        desc = "Pick a color.";
        cmd =
          # sh
          ''dms color pick -a'';
      }
    ];
  }
]
