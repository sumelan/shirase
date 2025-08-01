{ pkgs, ... }:
{
  qobuz-player = pkgs.callPackage ./qobuz-player { };
  everforest-cursors = pkgs.callPackage ./everforest-cursors { };
}
