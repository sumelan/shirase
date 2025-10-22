{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "materia-everforest-kvantum";
  version = "unstable-2024-01-22";

  src = fetchFromGitHub {
    owner = "binEpilo";
    repo = "materia-everforest-kvantum";
    rev = "391eb1d917dab900dc1ef16ffdff1a4546308ee4";
    hash = "sha256-5ihKScPJMDU0pbeYtUx/UjC4J08/r40mAK7D+1TK6wA=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/Kvantum
    cp -a -r MateriaEverforestDark $out/share/Kvantum
    runHook postInstall
  '';

  meta = {
    description = "";
    homepage = "https://github.com/binEpilo/materia-everforest-kvantum";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [sumelan];
    mainProgram = "materia-everforest-kvantum";
    platforms = lib.platforms.all;
  };
}
