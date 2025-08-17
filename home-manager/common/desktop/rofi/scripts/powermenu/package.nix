{
  lib,
  pkgs,
  ...
}:
pkgs.writers.writeFishBin "powermenu" ''
  set themeDir "$HOME/.config/rofi/theme"

  set uptime (${lib.getExe' pkgs.procps "uptime"} -p | sed -e 's/up //g')
  set host (hostname)

  set choices " Lock\n Suspend\n󰿅 Exit\n Reboot\n Shutdown"

  set confirms " Yes\n No"

  function rofi_cmd
      rofi -dmenu \
          -p "Goodbye $USER" \
              -mesg "Uptime: $uptime" \
                  -theme $themeDir/powermenu.rasi
  end

  function confirm_cmd
      rofi -dmenu \
          -p "Confirmation" \
              -mesg "Are you Sure?" \
                  -theme $themeDir/confirm.rasi
  end

  set choice (echo -en $choices | rofi_cmd)

  set confirm (echo -en $confirms | confirm_cmd)

  if string match (string split -f 2 " " $confirm) Yes
    switch (string split -f 2 " " $choice)
      case Lock
          ${lib.getExe pkgs.hyprlock}
      case Suspend
          systemctl suspend
      case Exit
          niri msg action quit --skip-confirmation
      case Reboot
          systemctl reboot
      case Shutdown
          systemctl poweroff
    end
  else
      exit 0
  end

''
