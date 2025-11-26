{pkgs, ...}: let
  soundPath = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo";

  dunstSoundScript =
    pkgs.writeShellScriptBin "dunst-sound"
    # sh
    ''
      if [[ "$DUNST_APP_NAME" != "Spotify" ]] && [[ "$DUNST_APP_NAME" != "Music Player Daemon" ]]; then
          if [[ "$DUNST_URGENCY" = "LOW" ]]; then
              pw-play ${soundPath}/message.oga
          elif [[ "$DUNST_URGENCY" = "NORMAL" ]]; then
              if [[ "$DUNST_APP_NAME" = "niri" ]]; then
                  pw-play ${soundPath}/camera-shutter.oga
              else
                  pw-play ${soundPath}/message-new-instant.oga
              fi
          else
              pw-play ${soundPath}/dialog-warning.oga
          fi
      fi
    '';
in {
  home.packages = [
    dunstSoundScript
  ];
}
