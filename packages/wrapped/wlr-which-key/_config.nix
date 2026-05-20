_: {
  # Theming
  font = "Maple Mono NF Bold Italic 14";
  background =
    "#4C566A"
    +
    # 65% opacity
    "A6";
  color = "#D79784";
  border = "#EFD49F";
  separator = " ➜ ";
  border_width = 2.0;
  corner_r = 0;
  padding = 15; # Defaults to corner_r
  rows_per_column = 4; # No limit by default
  column_padding = 40; # Defaults to padding

  # Anchor and margin
  anchor = "bottom"; # One of center, left, right, top, bottom, bottom-left, top-left, etc.
  # Only relevant when anchor is not center
  margin_right = 0;
  margin_bottom = 100;
  margin_left = 0;
  margin_top = 0;

  # Permits key bindings that conflict with compositor key bindings.
  # Default is `false`.
  inhibit_compositor_keyboard_shortcuts = false;

  # Try to guess the correct keyboard layout to use. Default is `false`.
  auto_kbd_layout = false;

  menu = let
    dms = key: import ./_dms-keys.nix {inherit key;};
    niri = key: import ./_niri-keys.nix {inherit key;};
  in
    dms "d" ++ niri "n";
}
