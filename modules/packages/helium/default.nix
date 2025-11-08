{
  lib,
  callPackage,
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
              --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,TouchpadOverscrollHistoryNavigation --enable-wayland-ime=true --password-store=basic"

          install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
          substituteInPlace $out/share/applications/${pname}.desktop \
            --replace 'Exec=AppRun' 'Exec=${pname}'
          cp -r ${appimageContents}/usr/share/icons $out/share
        '';

      extraBwrapArgs = [
        # xdg scheme-handlers
        "--ro-bind-try /etc/xdg/ /etc/xdg/"
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
