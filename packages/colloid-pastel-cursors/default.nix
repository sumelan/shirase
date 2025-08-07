{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "colloid-pastel-cursors";
  version = "unstable-2025-03-20";

  src = fetchFromGitHub {
    owner = "SueDonham";
    repo = "Colloid-pastel-icons";
    rev = "6ea7971c8fe9688701a6ed5752c2246b0046d1c6";
    hash = "sha256-xTiUVuOv3K7ZDwJ/1j7NNgreuxfMZuh6EKJENhuGWqA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r ${src}/cursors/dist-dark $out/share/icons

    runHook postInstall
  '';

  meta = {
    description = "Xcursor and hyprcursor themes based on those of Colloid-icon-theme";
    homepage = "https://github.com/SueDonham/Colloid-pastel-icons/tree/main/cursors";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [sumelan];
    mainProgram = "colloid-pastel-cursors";
    platforms = lib.platforms.all;
  };
}
