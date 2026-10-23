{
  pkgs,
  functions,
  pkg ? pkgs.ghostty,
  extraConfig ? {},
  ...
}: let
  inherit
    (pkgs.lib)
    recursiveUpdate
    mapAttrsToList
    concatStringsSep
    getExe
    ;
  inherit (functions.print) wrappedConfig;

  ghosttyConfig = let
    cfg = import ./_config.nix {};
    binds = import ./_binds.nix {};

    configLines = mapAttrsToList (k: v: "${k} = ${toString v}") (recursiveUpdate cfg extraConfig);
    bindsLines = mapAttrsToList (k: v: "keybind = ${k}=${v}") binds;
  in
    pkgs.writeText "ghostty-wrapped-config" (concatStringsSep "\n" (configLines ++ bindsLines));

  printPkg = wrappedConfig ghosttyConfig {
    name = "ghostty-print-config";
    lang = "ini";
  };

  wrapped-service = pkgs.writeText "wrapped-ghostty.service" ''
    [D-BUS Service]
    Name=com.mitchellh.ghostty
    SystemdService=app-com.mitchellh.ghostty.service
    Exec=${getExe pkg} --config-default-files=false --config-file=${ghosttyConfig} --gtk-single-instance=true --initial-window=false
  '';

  wrapped-desktopItem = pkgs.writeText "wrapped-ghostty.desktop" ''
    [Desktop Entry]
    Version=1.0
    Name=Ghostty
    Type=Application
    Comment=A terminal emulator
    TryExec=${getExe pkg} --config-file=${ghosttyConfig}
    Exec=${getExe pkg} --config-file=${ghosttyConfig} --gtk-single-instance=true
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
    Exec=${getExe pkg} --config-default-files=false --config-file=${ghosttyConfig} --gtk-single-instance=true

  '';
in
  pkgs.symlinkJoin {
    name = "ghostty";
    paths = [pkg];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      cp -r ${printPkg}/bin $out

      $out/bin/ghostty \
        --config-file=${ghosttyConfig} \
        +validate-config

      rm $out/bin/.ghostty-wrapped
      rm $out/share/applications/com.mitchellh.ghostty.desktop
      rm $out/share/dbus-1/services/com.mitchellh.ghostty.service

      ln -s ${wrapped-service} $out/share/dbus-1/services/com.mitchellh.ghostty.service
      ln -s ${wrapped-desktopItem} $out/share/applications/com.mitchellh.ghostty.desktop

      wrapProgram $out/bin/ghostty \
        --add-flags "--config-default-files=false" \
        --add-flags "--config-file=${ghosttyConfig}" \
        --set GHOSTTY_BIN_DIR $out/bin \
        --set GHOSTTY_RESOURCES_DIR $out/share/ghostty \
        --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = [pkgs.maple-mono.NF-unhinted];}}
    '';
    meta.mainProgram = "ghostty";
  }
