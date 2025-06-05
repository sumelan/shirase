{
  lib,
  stdenv,
  makeWrapper,
  fish,
  wf-recorder,
  slurp,
  gifsicle,
  zenity,
}:
stdenv.mkDerivation {
  pname = "record-screen";
  version = "1.1.0";

  src = ./scripts;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    for script in $src/*; do
      install -Dm755 "$script" "$out/bin/$(basename -s .fish $script)"
    done
  '';

  fixupPhase = ''
    echo $out
    for script in $out/bin/*; do
      wrapProgram "$script" --prefix PATH : ${
        lib.makeBinPath [
          fish
          wf-recorder
          slurp
          gifsicle
          zenity
        ]
      }
    done
  '';
}
