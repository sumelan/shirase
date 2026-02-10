{
  pkgs,
  menu,
  ...
}:
pkgs.writeText "config.yaml"
(pkgs.lib.generators.toYAML {} {
  # Theming
  font = "Maple Mono NF 14";
  background = "#2E3440" + "d0";
  color = "#81A1C1";
  border = "#80B3B2";
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

  inherit menu;
})
