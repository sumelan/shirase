{
  callPackage,
  lib,
  appimageTools,
  makeWrapper,
}: let
  pname = "helium";
  source = (callPackage ./generated.nix {}).helium;
  appimageContents = appimageTools.extract source;
in
  appimageTools.wrapType2 (
    source
    // {
      nativeBuildInputs = [makeWrapper];
      extraInstallCommands =
        #sh
        ''
          wrapProgram $out/bin/${pname} \
              --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

          install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
          substituteInPlace $out/share/applications/${pname}.desktop \
            --replace 'Exec=AppRun' 'Exec=${pname}'
          cp -r ${appimageContents}/usr/share/icons $out/share
        '';

      extraBwrapArgs = [
        # read policies from root fs from within the appimage sandbox
        "--ro-bind-try /etc/chromium/policies/managed/default.json /etc/chromium/policies/managed/default.json"
      ];

      meta = {
        description = "Private, fast, and honest web browser";
        homepage = "https://helium.computer/";
        maintainers = [lib.maintainers.sumelan];
        platforms = [
          "x86_64-linux"
          "aarch64-linux"
        ];
      };
    }
  )
