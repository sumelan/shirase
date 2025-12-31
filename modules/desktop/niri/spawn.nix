_: {
  flake.modules.homeManager.spawn = {
    xdg.configFile."niri/spawn.kdl".text =
      # kdl
      ''
        spawn-at-startup "blueman-applet"
        spawn-at-startup "easyeffects" "--hide-window"
        spawn-at-startup "nm-applet"
        spawn-at-startup "solaar" "-w" "hide" "-b" "symbolic"
        spawn-at-startup "brightnessctl" "set" "5%"
      '';
  };
}
