{ pkgs, ... }:
pkgs.writers.writePython3Bin "open-float" {
  libraries = with pkgs.python3Packages; [ ];

  flakeIgnore = [
    "F401"
    "E501"
    "W503"
  ];
} ./open-float.py
