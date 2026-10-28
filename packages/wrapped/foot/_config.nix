{pkgs}: {
  main = {
    font = "0xProto Nerd Font:size=14";
    initial-window-size-pixels = "1000x800";
    shell = "nu";
    include = pkgs.foot.themes + "/share/foot/themes/catppuccin-frappe";
  };

  scrollback = {
    lines = 100000;
  };

  cursor = {
    style = "beam";
    blink = true;
    blink-rate = 500;
    beam-thickness = 2.0;
  };

  mouse = {
    hide-when-typing = "yes";
  };
}
