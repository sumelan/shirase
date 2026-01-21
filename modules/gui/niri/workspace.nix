_: {
  flake.modules.homeManager.default = _: {
    xdg.configFile."niri/workspace.kdl".text =
      # kdl
      ''
        workspace "eizo" {
            open-on-output "Eizo Nanao Corporation EV2450 71147045"
            layout {
                default-column-width { proportion 1.0; }
                default-column-display "normal"
            }
        }
      '';
  };
}
