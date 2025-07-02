{
  lib,
  config,
  pkgs,
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
            app-id ? lib.getName app,
          }:
          {
            action = spawn' "${lib.getExe terminal} -o confirm_os_window_close=0 --app-id=${app-id} ${lib.getName app}";
            hotkey-overlay.title = "Launch ${app-id}";
          };

        run =
          {
            cmd,
            osd ? null,
            args ? "",
            title ? null,
            locked ? null,
            repeat ? null,
          }:
          {
            action.spawn =
              if osd == pkgs.swayosd then
                [
                  "fish"
                  "-c"
                  "${cmd} && ${lib.getName osd}-client ${args}"
                ]
              else
                [
                  "fish"
                  "-c"
                  cmd
                ];
            hotkey-overlay = if title == null then { hidden = true; } else { inherit title; };
            allow-when-locked = if locked == null then false else true;
            repeat = if repeat == null then true else false;
          };
      };
    };
}
