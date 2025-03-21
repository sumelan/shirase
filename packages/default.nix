{ pkgs, ... }:
{
  hypr-scripts = pkgs.callPackage ./hypr-scripts { };
  screencast = pkgs.callPackage ./screencast { };
}
