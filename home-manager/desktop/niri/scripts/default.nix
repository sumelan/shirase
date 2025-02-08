{ pkgs, ... }:
{
  home.packages = [
    (import ./create_or_focus_workspace.nix { inherit pkgs; })
    (import ./rename_workspace.nix { inherit pkgs; })
  ];
}
