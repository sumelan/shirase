{
  lib,
  config,
  user,
  ...
}:
{
  options.niri-lib = lib.mkOption {
    type = lib.types.attrs;
    description = "This option allows modules to define helper functions, constants, etc.";
    default = { };
  };

  config =
    let
      inherit (config.lib.niri) actions;
      terminal = config.profiles.${user}.defaultTerminal.package;
      osdCommand = "swayosd-client --monitor ${config.lib.monitors.mainMonitorName}";
    in
    {
      niri-lib = rec {
        uwsm = app: actions.spawn "fish" "-c" "uwsm app -- ${app}";
        spawn' = cmd: actions.spawn (lib.splitString " " cmd);

        open =
          {
            app,
            args ? "",
            title ? "Launch ${lib.getName app}",
          }:
          {
            action = uwsm (lib.strings.trim "${lib.getExe app} ${args}");
            hotkey-overlay = { inherit title; };
          };

        open-tui =
          {
            app,
            app-id,
          }:
          {
            action = spawn' "${lib.getExe terminal} -o confirm_os_window_close=0 --app-id=${app-id} ${lib.getName app}";
            hotkey-overlay.title = "Launch ${app-id}";
          };

        run =
          {
            cmd,
            title ? null,
            osd ? null,
            message ? null,
            icon ? null,
          }:
          {
            action.spawn =
              if osd == null then
                [
                  "fish"
                  "-c"
                  cmd
                ]
              else
                [
                  "fish"
                  "-c"
                  "${cmd} && ${osdCommand} --custom-message=${message} --custom-icon=${icon}"
                ];
            hotkey-overlay = if title == null then { hidden = true; } else { inherit title; };
          };
      };
    };
}
