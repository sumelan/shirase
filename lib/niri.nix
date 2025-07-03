{ lib }:
rec {
  useUwsm = app: [
    "fish"
    "-c"
    "uwsm app -- ${app}"
  ];

  mkSpawn = cmd: lib.splitString " " cmd;

  openApp =
    {
      app,
      args ? "",
      title ? "Launch ${lib.getName app}",
    }:
    {
      action.spawn = useUwsm (lib.strings.trim "${lib.getName app} ${args}");
      hotkey-overlay = { inherit title; };
    };
  openTerminal =
    {
      app,
      terminal,
      app-id ? lib.getName app,
    }:
    {
      action.spawn = mkSpawn "${lib.getExe terminal} -o confirm_os_window_close=0 --app-id=${app-id} ${lib.getName app}";
      hotkey-overlay.title = "Launch ${app-id}";
    };

  runCmd =
    {
      cmd,
      osd ? "",
      osdArgs ? "",
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
            "${cmd} && ${osd}-client ${osdArgs}"
          ]
        else
          [
            "fish"
            "-c"
            cmd
          ];
      hotkey-overlay = if title == null then { hidden = true; } else { inherit title; };
      allow-when-locked = if locked == "allow" then true else false;
      repeat = if repeat == "no" then false else true;
    };

}
