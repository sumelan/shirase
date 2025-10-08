_: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        initial-window-size-pixels = "1200x800";
      };
      scrollback = {
        lines = 10000;
      };
      cursor = {
        style = "beam";
        blink = "yes";
        blink-rate = 500;
        beam-thickness = 2.0;
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
