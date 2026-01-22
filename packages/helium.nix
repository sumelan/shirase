_: {
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    source = (pkgs.callPackage ../_sources/generated.nix {}).helium;
    inherit (source) pname version src;
    contents = pkgs.appimageTools.extract source;

    nativeBuildInputs = [pkgs.makeWrapper];
    extraInstallCommands =
      #sh
      ''
        wrapProgram $out/bin/${pname} \
            --add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,TouchpadOverscrollHistoryNavigation --enable-wayland-ime=true --password-store=basic"

        install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/${pname}.desktop \
            --replace 'Exec=AppRun' 'Exec=${pname}'
        cp -r ${contents}/usr/share/icons $out/share
      '';

    extraBwrapArgs = [
      # chromium policies
      "--ro-bind-try /etc/chromium/policies/managed/default.json /etc/chromium/policies/managed/default.json"
      # xdg scheme-handlers
      "--ro-bind-try /etc/xdg/ /etc/xdg/"
    ];

    localPkg = pkgs.appimageTools.wrapType2 {
      inherit pname version src nativeBuildInputs extraInstallCommands extraBwrapArgs;
    };
  in
    # Helium is only available on linux and bwrap is a linux only utility
    lib.optionalAttrs (lib.hasSuffix "linux" system) {
      packages = {
        helium = localPkg;
      };
    };
}
