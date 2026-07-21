{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom.wrappers) mkGhosttyConfig;
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {pkgs, ...}: let
    pkg = pkgs.ghostty;
    extraConfig = {command = "nu";};
  in {
    packages = {
      ghostty = config.flake.custom.wrappers.mkGhostty {
        inherit pkg pkgs extraConfig;
      };
    };
  };

  flake.custom.wrappers = {
    mkGhosttyConfig = {
      pkgs,
      extraConfig ? {},
      extraBinds ? {},
    }: let
      cfg = import ./_config.nix {};
      binds = import ./_binds.nix {};

      allConfig = cfg // extraConfig;
      allBinds = binds // extraBinds;
      configLines = lib.mapAttrsToList (k: v: "${k} = ${toString v}") allConfig;
      bindsLines = lib.mapAttrsToList (k: v: "keybind = ${k}=${v}") allBinds;
    in
      pkgs.writeText "ghostty-wrapped-config" (lib.concatStringsSep "\n" (configLines ++ bindsLines));

    mkGhostty = {
      pkgs,
      pkg ? pkgs.ghostty,
      extraConfig ? {},
      extraBinds ? {},
    }: let
      cfg = mkGhosttyConfig {inherit pkgs extraConfig extraBinds;};

      printCfg = printConfig {
        inherit cfg pkgs;
        name = "ghostty-print-config";
        lang = "ini";
      };

      wrapped-service = pkgs.writeText "wrapped-ghostty.service" ''
        [D-BUS Service]
        Name=com.mitchellh.ghostty
        SystemdService=app-com.mitchellh.ghostty.service
        Exec=${lib.getExe pkg} --config-file=${cfg} --gtk-single-instance=true --initial-window=false
      '';

      wrapped-desktopItem = pkgs.writeText "wrapped-ghostty.desktop" ''
        [Desktop Entry]
        Version=1.0
        Name=Ghostty
        Type=Application
        Comment=A terminal emulator
        TryExec=${lib.getExe pkg} --config-file=${cfg}
        Exec=${lib.getExe pkg} --config-file=${cfg} --gtk-single-instance=true
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
        Exec=${lib.getExe pkg} --config-file=${cfg} --gtk-single-instance=true

      '';
    in
      pkgs.symlinkJoin {
        name = "ghostty";
        paths = [pkg];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          rm $out/bin/.ghostty-wrapped
          rm $out/share/applications/com.mitchellh.ghostty.desktop
          rm $out/share/dbus-1/services/com.mitchellh.ghostty.service

          ln -s ${wrapped-service} $out/share/dbus-1/services/com.mitchellh.ghostty.service
          ln -s ${wrapped-desktopItem} $out/share/applications/com.mitchellh.ghostty.desktop

          wrapProgram $out/bin/ghostty \
            --add-flags "--config-default-files=false --config-file=${cfg}" \
            --set GHOSTTY_BIN_DIR $out/bin \
            --set GHOSTTY_RESOURCES_DIR $out/share/ghostty \
            --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = [pkgs.maple-mono.NF-unhinted];}}
        '';
        meta.mainProgram = "ghostty";
      };
  };
}
