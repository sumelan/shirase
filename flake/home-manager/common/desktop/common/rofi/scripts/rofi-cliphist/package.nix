{
  lib,
  pkgs,
  ...
}:
pkgs.writers.writeFishBin "clipboard-history" ''
  set themeDir "$HOME/.config/rofi/theme"

  function rofi_cmd
      rofi -dmenu \
          -p "Clipboard History" \
              -mesg "Select to paste" \
                  -theme $themeDir/cliphist.rasi
  end

  ${lib.getExe pkgs.cliphist} list \
      | rofi_cmd | \
          ${lib.getExe pkgs.cliphist} decode | \
              ${lib.getExe' pkgs.wl-clipboard "wl-copy"}
''
