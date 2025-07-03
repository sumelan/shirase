{ pkgs, lib, ... }:
pkgs.writers.writeFishBin "fuzzel-clipboard" ''
  ${lib.getExe pkgs.cliphist} list | fuzzel --dmenu --prompt "󰅇 " --placeholder "Search for clipboard entries..." --no-sort | ${lib.getExe pkgs.cliphist} decode | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}
''
