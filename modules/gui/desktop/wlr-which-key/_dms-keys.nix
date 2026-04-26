{key, ...}: [
  {
    key = key;
    desc = "DankMaterialShell ipc keys.";
    submenu = [
      {
        key = "d";
        desc = "Dashboard popup with multiple tabs.";
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
            desc = "Toggle Weather tab.";
            cmd =
              # sh
              ''dms ipc dash toggle weather'';
          }
        ];
      }
      {
        key = "l";
        desc = "Toggle nightlight.";
        cmd =
          # sh
          ''dms ipc night toggle'';
      }
      {
        key = "m";
        desc = "Open processlist.";
        cmd =
          # sh
          ''dms ipc processlist focusOrToggle'';
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
      {
        key = "s";
        desc = "Screenshot with annotations.";
        submenu = [
          {
            key = "f";
            desc = "Focused output.";
            cmd =
              # sh
              ''dms screenshot full --stdout | satty -f -'';
          }
          {
            key = "r";
            desc = "Selected resion.";
            cmd =
              # sh
              ''dms screenshot --stdout | satty -f -'';
          }
        ];
      }
      {
        key = "v";
        desc = "Toggle bar visibility.";
        cmd =
          # sh
          ''dms ipc bar toggle name "Main Bar"'';
      }
    ];
  }
]
