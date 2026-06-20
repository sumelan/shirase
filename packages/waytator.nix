_: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.waytator = pkgs.stdenv.mkDerivation (finalAttrs: {
      pname = "waytator";
      version = "1.2.4";
      __structuredAttrs = true;
      strictDeps = true;

      src = pkgs.fetchFromGitHub {
        owner = "faetalize";
        repo = "waytator";
        tag = "v${finalAttrs.version}";
        hash = "sha256-/Tq4fVrgss/v/+ugAueWCx1mbQlsyQ0LE4jRtIhT4qU=";
      };

      nativeBuildInputs = [
        pkgs.meson
        pkgs.ninja
        pkgs.pkg-config
        pkgs.makeWrapper
      ];

      buildInputs = [
        pkgs.gtk4
        pkgs.libadwaita
        pkgs.tesseract
      ];

      postFixup = ''
        wrapProgram $out/bin/waytator \
          --prefix PATH : ${lib.makeBinPath [pkgs.tesseract]}
      '';

      mesonBuildType = "release";

      passthru.updateScript = pkgs.nix-update-script {};

      meta = {
        description = "Wayland image annotation tool";
        homepage = "https://github.com/faetalize/waytator";
        changelog = "https://github.com/faetalize/waytator/releases/tag/${finalAttrs.src.tag}";
        license = lib.licenses.gpl3Only;
        maintainers = with lib.maintainers; [sumelan];
        mainProgram = "waytator";
        platforms = lib.platforms.all;
      };
    });
  };
}
