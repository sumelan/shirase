{
  self,
  inputs,
  pkgs,
  functions,
  pkg ? pkgs.mango,
  extraRawConfig ? "",
  extraRuntimeInputs ? [],
  ...
}: let
  inherit (pkgs) lib;
  inherit (functions.recursive) attrsList;
  inherit (functions.print) wrappedConfig;

  cfg = attrsList [
    (import ./_autostart_sh.nix {inherit pkgs;})
    (import ./_bindings.nix {inherit pkgs;})
    (import ./_config.nix {inherit pkgs;})
    (import ./_visuals.nix {})
    (import ./_window.nix {inherit pkgs;})
    (import ./_theming.nix {})
  ];
  mlib = import (inputs.mangowm + "/nix/lib.nix") lib;

  finalConfigText = mlib.toMango {} cfg;

  # mango-config.conf without extraConfig; like `source = foo.conf`
  checkConfig = pkgs.writeText "mango-config.conf" finalConfigText;
  mangoConfig = pkgs.writeText "mango-config.conf" (finalConfigText + extraRawConfig);

  runtimeEnv = let
    helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in
    pkgs.buildEnv {
      name = "mango-runtime-env";
      pathsToLink = ["/bin"];
      paths = with pkgs;
        [
          dbus
          systemd
          xdg-desktop-portal-wlr
          capitaine-cursors-themed
          brightnessctl
          libnotify
          playerctl
          vellum
        ]
        ++ (with self.packages.${pkgs.stdenv.hostPlatform.system}; [
          broot
          ns
          noctalia
          ghostty
        ])
        ++ [
          helium
        ]
        ++ extraRuntimeInputs;
    };

  printPkg = wrappedConfig mangoConfig {
    name = "mango-print-config";
  };
in
  pkgs.symlinkJoin {
    name = "mango";
    paths = [pkg];
    nativeBuildInputs = [pkgs.makeWrapper];
    passthru.providedSessions = ["mango"];
    postBuild = ''
      cp -r ${printPkg}/bin $out

      $out/bin/mango -c ${checkConfig} -p

      wrapProgram $out/bin/mango \
        --add-flags "-c ${mangoConfig}" \
        --prefix PATH : ${runtimeEnv}/bin
    '';
    meta.mainProgram = "mango";
  }
