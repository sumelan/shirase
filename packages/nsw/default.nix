{
  git,
  nh,
  lib,
  stdenvNoCC,
  makeWrapper,
  # variables
  dotfiles ? "$HOME/projects/wolborg",
  name ? "nsw",
  host ? "desktop",
}:
stdenvNoCC.mkDerivation {
  inherit name;
  version = "1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace nsw.sh \
      --replace-fail "@dots@" "${dotfiles}" \
      --replace-fail "@host@" "${host}"
  '';

  postInstall = ''
    install -D ./nsw.sh $out/bin/nsw

    wrapProgram $out/bin/nsw \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          nh
        ]
      }
  '';

  meta = {
    description = "nh wrapper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iynaix ];
    platforms = lib.platforms.linux;
  };
}
