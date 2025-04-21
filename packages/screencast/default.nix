{
  lib,
  stdenv,
  makeWrapper,
  fish,
  libnotify,
  wl-screenrec,
  procps,
}:
stdenv.mkDerivation {
  pname = "screencast";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 $src/screencast.fish $out/bin/screencast
  '';

  postInstall = ''
    wrapProgram $out/bin/screencast --set PATH ${
      lib.makeBinPath [
        fish
        libnotify
        wl-screenrec
        procps
      ]
    }
  '';
}
