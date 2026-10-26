{
  pkgs,
  functions,
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

    extraConfig = {
      shell-integration = "nushell";
      theme = "Catppuccin Frappe";
      font-feature = concatStringsSep "," [
        "+calt" # default ligatures
        "+zero" # alternate zero
        "+cv62" # alternative question
        "+cv63" # alternative left arrow
        "+cv66" # alternative pipe arrows
        "+ss03" # arbitary tag
        "+ss05" # thin escape backslash
        "+ss07" # relax multi-greaters condition
        "+ss08" # double / back rows
        "+ss09" # alternative not equal
        "+ss10" # aaproximately equal
        "+ss11" # extra equal ligatures
      ];
    };

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
    Exec=${getExe pkgs.ghostty} --config-default-files=false --config-file=${ghosttyConfig} --gtk-single-instance=true --initial-window=false
  '';

  wrapped-desktopItem = pkgs.writeText "wrapped-ghostty.desktop" ''
    [Desktop Entry]
    Version=1.0
    Name=Ghostty
    Type=Application
    Comment=A terminal emulator
    TryExec=${getExe pkgs.ghostty} --config-file=${ghosttyConfig}
    Exec=${getExe pkgs.ghostty} --config-file=${ghosttyConfig} --gtk-single-instance=true
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
    Exec=${getExe pkgs.ghostty} --config-default-files=false --config-file=${ghosttyConfig} --gtk-single-instance=true

  '';
in
  pkgs.symlinkJoin {
    name = "ghostty";
    paths = with pkgs; [ghostty];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      ln -s ${printPkg}/bin/ghostty-print-config $out/bin/ghostty-print-config

      $out/bin/ghostty --config-file=${ghosttyConfig} +validate-config

      rm -f $out/bin/.ghostty-wrapped
      rm -f $out/share/applications/com.mitchellh.ghostty.desktop
      rm -f $out/share/dbus-1/services/com.mitchellh.ghostty.service

      ln -sf ${wrapped-service} $out/share/dbus-1/services/com.mitchellh.ghostty.service
      ln -sf ${wrapped-desktopItem} $out/share/applications/com.mitchellh.ghostty.desktop

      wrapProgram $out/bin/ghostty \
        --add-flags "--config-default-files=false" \
        --add-flags "--config-file=${ghosttyConfig}" \
        --set GHOSTTY_BIN_DIR $out/bin \
        --set GHOSTTY_RESOURCES_DIR $out/share/ghostty \
        --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = [pkgs.maple-mono.NF-unhinted];}}
    '';
    meta.mainProgram = "ghostty";
  }
