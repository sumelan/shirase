[
  {
    key = "d";
    desc = "Open dashboard";
    cmd = "dms ipc dash toggle '[tab]'";
  }
  {
    key = "m";
    desc = "Open processlist";
    cmd = "dms ipc processlist focusOrToggle";
  }
  {
    key = "n";
    desc = "Toggle nightlight";
    cmd = "dms ipc night toggle";
  }
  {
    key = "p";
    desc = "Pick a color";
    cmd = "dms color pick -a";
  }
  {
    key = "s";
    desc = "Screenshot with annotation";
    submenu = [
      {
        key = "f";
        desc = "Focused output";
        cmd = "dms screenshot full --stdout | satty -f -";
      }
      {
        key = "r";
        desc = "Selected resion";
        cmd = "dms screenshot --stdout | satty -f -";
      }
    ];
  }
  {
    key = "v";
    desc = "Toggle bar visibility";
    cmd = "dms ipc bar toggle name 'Main Bar'";
  }
]
