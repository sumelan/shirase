{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  themeVariants ? [],
}:
stdenvNoCC.mkDerivation rec {
  pname = "qogir-cursors";
  version = "2025-02-15";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Qogir-icon-theme";
    rev = version;
    hash = "sha256-Eh4TWoFfArFmpM/9tkrf2sChQ0zzOZJE9pElchu8DCM=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r ${src}/src/cursors/dist-${builtins.toString themeVariants}-Dark $out/share/icons

    runHook postInstall
  '';

  meta = {
    description = "A colorful design icon theme for linux desktops";
    homepage = "https://github.com/vinceliuice/Qogir-icon-theme/tree/master/src/cursors";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [sumelan];
    mainProgram = "qogir-cursors";
    platforms = lib.platforms.all;
  };
}
