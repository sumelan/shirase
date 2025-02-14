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
  pname = "niricast";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    install -Dm755 $src/niricast.fish $out/bin/niricast
  '';

  postInstall = ''
    wrapProgram $out/bin/niricast --set PATH ${
      lib.makeBinPath [
        fish
        libnotify
        wl-screenrec
        procps
      ]
    }
  '';
}
