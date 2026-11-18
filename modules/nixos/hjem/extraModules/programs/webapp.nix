{
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit
    (pkgs.lib)
    mkIf
    mkEnableOption
    mkOption
    getExe
    ;
  inherit (pkgs.lib.types) str package;
  cfg = config.rum.programs.webapp;
  browser = "helium";
  browserPkg = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  options.rum = {
    programs.webapp = {
      enable = mkEnableOption "helium webapp";
      app = {
        name = mkOption {
          type = str;
          default = "";
        };
        class = mkOption {
          type = str;
          default = cfg.app.name + "-webapp";
        };
        url = mkOption {
          type = str;
          default = "";
        };
        icon = mkOption {
          type = package;
          default = "";
        };
      };
    };
  };

  config = let
    launcher = pkgs.writeShellApplication {
      inherit (cfg.app) name;
      runtimeInputs = [browserPkg];
      text = ''
        exec ${browser} \
          --app="${cfg.app.url}" \
          --user-data-dir="$HOME/.local/share/${cfg.app.class}" \
          --class=${cfg.app.class} \
          --no-first-run \
          --no-default-browser-check \
          "$@"
      '';
    };

    desktopEntry = ''
      [Desktop Entry]
      Type=Application
      Version=1.5
      Name=${cfg.app.name}
      GenericName=Misskey client
      Comment=${cfg.app.url} in an app window
      Exec=${getExe launcher}
      Icon=${cfg.app.icon}
      Terminal=false
      Categories=Network;InstantMessaging;
      Keywords=misskey;sns;fediverse;activitypub;
      StartupWMClass=${cfg.app.class}
      StartupNotify=true
    '';
  in
    mkIf cfg.enable {
      packages = [launcher];

      xdg.data.files = {
        "applications/${cfg.app.name}.desktop".text = desktopEntry;
        "icons/hicolor/256x256/apps/${cfg.app.name}.png".source = cfg.app.icon;
      };
    };
}
