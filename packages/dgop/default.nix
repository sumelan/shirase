{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "dgop";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dgop";
    rev = "v${version}";
    hash = "sha256-QCJbcczQjUZ+Xf7tQHckuP9h8SD0C4p0C8SVByIAq/g=";
  };

  vendorHash = "sha256-+5rN3ekzExcnFdxK2xqOzgYiUzxbJtODHGd4HVq6hqk=";

  subPackages = ["cmd/cli"];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/AvengeMedia/dgop.VERSION=${version}"
    "-X github.com/AvengeMedia/dgop.GIT_COMMIT=v${version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/dgop
  '';

  meta = {
    description = "API & CLI for System Resources";
    homepage = "https://github.com/AvengeMedia/dgop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [sumelan];
    mainProgram = "dgop";
  };
}
