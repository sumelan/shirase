{pkgs, ...}: let
  rofi-clipboard =
    pkgs.writeShellScriptBin "clipboard-history"
    # sh
    ''
      themeDir=$HOME/.config/rofi/themes

      rofi_cmd () {
          rofi -dmenu -p "Clipboard History" -mesg "Select to paste" -theme "$themeDir/cliphist.rasi"
      }

      cliphist list | rofi_cmd | cliphist decode | wl-copy

    '';
in {
  home.packages = [
    rofi-clipboard
  ];
}
