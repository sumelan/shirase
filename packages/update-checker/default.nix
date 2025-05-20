{
  lib,
  stdenv,
  makeWrapper,
  fish,
  libnotify,
  nh,
}:
stdenv.mkDerivation {
  pname = "update-checker";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 $src/update-checker.fish $out/bin/update-checker
  '';

  postInstall = ''
    wrapProgram $out/bin/update-checker --set PATH ${
      lib.makeBinPath [
        fish
        libnotify
        nh
      ]
    }
  '';
}
