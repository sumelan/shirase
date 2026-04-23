_: {
  # Theming
  background = "#51576D" + "BF";
  color = "#F2D5CF";
  border = "#99D1DB";
  separator = " ➜ ";
  border_width = 2;
  corner_r = 10;
  padding = 15; # Defaults to corner_r
  rows_per_column = 5; # No limit by default
  column_padding = 25; # Defaults to padding

  # Anchor and margin
  anchor = "bottom"; # One of center, left, right, top, bottom, bottom-left, top-left, etc.
  # Only relevant when anchor is not center
  margin_right = 0;
  margin_bottom = 5;
  margin_left = 0;
  margin_top = 0;

  # Permits key bindings that conflict with compositor key bindings.
  # Default is `false`.
  inhibit_compositor_keyboard_shortcuts = true;

  # Try to guess the correct keyboard layout to use. Default is `false`.
  auto_kbd_layout = true;

  menu = [
    {
      key = "n";
      desc = "niri command";
      submenu = [
        {
          key = "w";
          desc = "Select a window as the dynamic cast target";
          cmd = "niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)";
        }
        {
          key = "o";
          desc = "Set the dynamic cast target to the focused monitor";
          cmd = "niri msg action set-dynamic-cast-monitor";
        }
        {
          key = "c";
          desc = "Clear the dynamic cast target";
          cmd = "niri msg action clear-dynamic-cast-target";
        }
      ];
    }
    {
      key = "d";
      desc = "dms command";
      submenu = [
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
      ];
    }
  ];
}
