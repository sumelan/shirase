{
  lib,
  pkgs,
}: rec {
  useUwsm = app: [
    "sh"
    "-c"
    "uwsm app -- ${app}"
  ];

  mkSpawn = cmd: lib.splitString " " cmd;

  openApp = {
    app,
    args ? "",
    title ? ''<span foreground="#f2d5cf">[Application]</span> ${lib.getName app}'',
  }: {
    action.spawn = useUwsm (lib.strings.trim "${lib.getName app} ${args}");
    hotkey-overlay = {inherit title;};
  };
  openTerminal = {
    app,
    terminal ? pkgs.kitty,
    app-id ? lib.getName app,
  }: {
    action.spawn = mkSpawn "${lib.getExe terminal} -o confirm_os_window_close=0 --app-id=${app-id} ${lib.getName app}";
    hotkey-overlay.title = ''<span foreground="#f2d5cf">[Terminal]</span> ${app-id}'';
  };

  runCmd = {
    cmd,
    title ? null,
  }: {
    action.spawn = [
      "sh"
      "-c"
      cmd
    ];
    hotkey-overlay =
      if title == null
      then {hidden = true;}
      else {inherit title;};
  };
}
