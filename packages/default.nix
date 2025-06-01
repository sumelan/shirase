{ pkgs, ... }:
{
  btrfs-scripts = pkgs.callPackage ./btrfs-scripts { };
  fuzzel-scripts = pkgs.callPackage ./fuzzel-scripts { };
  hypr-scripts = pkgs.callPackage ./hypr-scripts { };
}
