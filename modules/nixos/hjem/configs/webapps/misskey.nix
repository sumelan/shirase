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
      url = "https://media.misskeyusercontent.jp/io/2f626cae-dc9b-435d-8ec3-7e3e8a25005b.png";
      hash = "sha256-0qtRSkNRNsbc7EbXn2DqYxZ18lbp7rhSejXln6t5sHM=";
    };

    launcher = pkgs.writeShellApplication {
      name = "misskey";
      runtimeInputs = [browserPkg];
      text = ''
        exec ${browser} \
          --app="https://misskey.io/" \
          --user-data-dir="$HOME/.local/share/webapp/misskey" \
          --class=misskey \
          --no-first-run \
          --no-default-browser-check \
          "$@"
      '';
    };

    desktopEntry = ''
      [Desktop Entry]
      Type=Application
      Version=1.5
      Name=Misskey.io
      GenericName=Misskey client (io)
      Comment=https://misskey.io/ in an app window
      Exec=${getExe launcher}
      Icon=${icon}
      Terminal=false
      Categories=Network;InstantMessaging;
      Keywords=misskey;sns;fediverse;activitypub;
      StartupWMClass=misseky
      StartupNotify=true
    '';
  in {
    packages = [launcher];

    xdg.data.files = {
      "applications/misskey.desktop".text = desktopEntry;
      "icons/hicolor/256x256/apps/misskey.png".source = icon;
    };
  };

  custom.fileSystem = {
    persist.home.directories = [
      ".local/share/webapp/misskey"
    ];
  };
}
