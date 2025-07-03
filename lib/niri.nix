{ lib }:
rec {
  useUwsm = cmd: [
    "fish"
    "-c"
    "uwsm app -- ${cmd}"
  ];

  mkSpawn = cmd: lib.splitString " " cmd;

  openApp =
    {
      app,
      args ? "",
      title ? "Launch ${app}",
    }:
    {
      action.spawn = useUwsm (lib.strings.trim "${app} ${args}");
      hotkey-overlay = { inherit title; };
    };
  openTerminal =
    {
      app,
      terminal ? "kitty",
      app-id ? app,
    }:
    {
      action.spawn = mkSpawn "${terminal} -o confirm_os_window_close=0 --app-id=${app-id} ${app}";
      hotkey-overlay.title = "Launch ${app-id}";
    };

  runCmd =
    {
      cmd,
      osd ? null,
      args ? "",
      title ? null,
      locked ? "no",
      repeat ? "yes",
    }:
    {
      action.spawn =
        if osd == "swayosd" then
          [
            "fish"
            "-c"
            "${cmd} && ${osd}-client ${args}"
          ]
        else
          [
            "fish"
            "-c"
            cmd
          ];
      hotkey-overlay = if title == null then { hidden = true; } else { inherit title; };
      allow-when-locked = if locked == "no" then false else true;
      repeat = if repeat == "yes" then true else false;
    };

}
