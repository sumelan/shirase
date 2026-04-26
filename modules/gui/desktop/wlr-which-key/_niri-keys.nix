{key, ...}: [
  {
    key = key;
    desc = "niri ipc keys.";
    submenu = [
      {
        key = "d";
        desc = "niri dynamic-cast-target keys.";
        submenu = [
          {
            key = "w";
            desc = "Select a window as the dynamic-cast-target.";
            cmd =
              # sh
              ''niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)'';
          }
          {
            key = "o";
            desc = "Set the dynamic-cast-target to the focused monitor.";
            cmd =
              #sh
              ''niri msg action set-dynamic-cast-monitor'';
          }
          {
            key = "c";
            desc = "Clear the dynamic cast target.";
            cmd = "niri msg action clear-dynamic-cast-target";
          }
        ];
      }
      {
        key = "o";
        desc = "Change outputs configuration temporarily.";
        submenu = [
          {
            key = "l";
            desc = ''Change the configuration of "LG Electronics LG HDR 4K".'';
            submenu = [
              {
                key = "1";
                desc = "Change the scale to 1.0.";
                cmd =
                  # sh
                  ''niri msg output "LG Electronics LG HDR 4K 0x000382AB" scale 1.0'';
              }
              {
                key = "2";
                desc = "Change the scale to 1.5.";
                cmd =
                  # sh
                  ''niri msg output "LG Electronics LG HDR 4K 0x000382AB" scale 1.5'';
              }
            ];
          }
        ];
      }
    ];
  }
]
