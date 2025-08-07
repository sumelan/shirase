{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  hicolor-icon-theme,
  libsForQt5,
  jdupes,
}:
stdenv.mkDerivation rec {
  pname = "colloid-pastel-icons";
  version = "unstable-2025-03-20";

  src = fetchFromGitHub {
    owner = "SueDonham";
    repo = "Colloid-pastel-icons";
    rev = "6ea7971c8fe9688701a6ed5752c2246b0046d1c6";
    hash = "sha256-xTiUVuOv3K7ZDwJ/1j7NNgreuxfMZuh6EKJENhuGWqA=";
  };

  dontCheckForBrokenSymlinks = true;

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  propagatedBuildInputs = [
    hicolor-icon-theme
    libsForQt5.breeze-icons
  ];

  dontDropIconThemeCache = true;

  # These fixup steps are slow and unnecessary for this package.
  # Package may install almost 400 000 small files.
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  patches = [./install.patch];

  postPatch = ''
    patchShebangs install.sh
  '';

  installPhase = ''
    runHook preInstall

    name= ./install.sh \
      --dest $out/share/icons

    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = {
    description = "Pastel version of Colloid icon theme";
    homepage = "https://github.com/SueDonham/Colloid-pastel-icons";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [sumelan];
    mainProgram = "colloid-pastel-icons";
    platforms = lib.platforms.all;
  };
}
