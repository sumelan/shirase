{
  pkgs,
  ghosttyConfig,
}:
pkgs.writeText "wrapped-ghostty.desktop" ''
  [Desktop Entry]
  Version=1.0
  Name=Ghostty
  Type=Application
  Comment=A terminal emulator
  TryExec=${pkgs.lib.getExe pkgs.ghostty} --config-file=${ghosttyConfig}
  Exec=${pkgs.lib.getExe pkgs.ghostty} --config-file=${ghosttyConfig} --gtk-single-instance=true
  Icon=com.mitchellh.ghostty
  Categories=System;TerminalEmulator;
  Keywords=terminal;tty;pty;
  StartupNotify=true
  StartupWMClass=com.mitchellh.ghostty
  Terminal=false
  Actions=new-window;
  X-GNOME-UsesNotifications=true
  X-TerminalArgExec=-e
  X-TerminalArgTitle=--title=
  X-TerminalArgAppId=--class=
  X-TerminalArgDir=--working-directory=
  X-TerminalArgHold=--wait-after-command
  DBusActivatable=true
  X-KDE-Shortcuts=Ctrl+Alt+T

  [Desktop Action new-window]
  Name=New Window
  Exec=${pkgs.lib.getExe pkgs.ghostty} --config-default-files=false --config-file=${ghosttyConfig} --gtk-single-instance=true
''
