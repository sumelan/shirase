_: {
  flake.modules.homeManager.default = {
    xdg.configFile."niri/spawn.kdl".text =
      # kdl
      ''
        spawn-at-startup "blueman-applet"
        spawn-at-startup "easyeffects" "--hide-window"
        spawn-at-startup "nm-applet"
        spawn-at-startup "solaar" "-w" "hide" "-b" "symbolic"
      '';
  };
}
