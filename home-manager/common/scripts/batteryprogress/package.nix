{ pkgs, ... }:
pkgs.writers.writeFishBin "show_battery_progress" ''
  set battery (cat /sys/class/power_supply/BAT*/capacity)
  math $battery / 100
''
