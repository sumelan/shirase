{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) getExe;
in {
  hjem.users.sumelan = let
    browser = "helium";
    browserPkg = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;

    icon = pkgs.fetchurl {
      url = "http://192.168.68.62:8234/audiobookshelf/_nuxt/img/icon.d3d4aef.svg";
      hash = "sha256-VguvRkIuP/UW0km0Sb0zHWslfxCZoTAVDhCEWoySKmk=";
    };

    launcher = pkgs.writeShellApplication {
      name = "audiobookshelf";
      runtimeInputs = [browserPkg];
      text = ''
        exec ${browser} \
          --app="http://192.168.68.62:8234" \
          --user-data-dir="$HOME/.local/share/webapp/audiobookshelf" \
          --class=audiobookshelf \
          --no-first-run \
          --no-default-browser-check \
          "$@"
      '';
    };

    desktopEntry = ''
      [Desktop Entry]
      Type=Application
      Version=1.5
      Name=Audiobookshelf
      GenericName=My audiobookshelf client
      Comment=My audiobookshelf in an app window
      Exec=${getExe launcher}
      Icon=${icon}
      Terminal=false
      Categories=Network;
      Keywords=audiobookshelf;selfhost;
      StartupWMClass=audiobookshelf
      StartupNotify=true
    '';
  in {
    packages = [launcher];

    xdg.data.files = {
      "applications/audiobookshelf.desktop".text = desktopEntry;
      "icons/hicolor/256x256/apps/audiobookshelf.png".source = icon;
    };
  };

  custom.fileSystem = {
    persist.home.directories = [
      ".local/share/webapp/audiobookshelf"
    ];
  };
}
