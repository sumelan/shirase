{
  pkgs,
  extraFiles,
  ...
}:
pkgs.writeText "ripgrep-ignore" ''
  .envrc
  .direnv
  .devenv
  .ignore
  *.lock
  generated.nix
  generated.json
  ${extraFiles}
''
