{customLib, ...}: let
  inherit (customLib.niri) hotkey;
in {
  custom.wayland.windowManager.niri = {
    extraBinds = {
      "Mod+Shift+B" = {
        _props.hotkey-overlay-title = hotkey {
          color = "#e5c890";
          name = "󰆚  Broot";
          desc = "TUI File Manager";
        };
        spawn = ["monstar" "--title" "broot" "-e" "broot"];
      };
    };

    extraWindow-rule = [
      {
        match = [
          {_props.title._raw = ''r#"^broot$"#'';}
        ];
        block-out-from = "screen-capture";
      }
    ];
  };
}
