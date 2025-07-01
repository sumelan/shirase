{ pkgs, ... }:
pkgs.writers.writeFishBin "write_battery_info" ''
  function power_profile
      set ppd (powerprofilesctl get)
      if string match $ppd "power-saver" > /dev/null
          echo " "
      else if string match $ppd "balanced" > /dev/null
          echo " "
      else
          echo " "
      end
  end

  set battery (cat /sys/class/power_supply/BAT*/capacity)
  set battery_status (cat /sys/class/power_supply/BAT*/status)
  set profile (power_profile)

  set charging_prefixs $profile $profile $profile $profile $profile $profile $profile $profile $profile "$profile"
  set discharging_prefixs " Critical!! - $profile" " Causion! - $profile" " Low - $profile" $profile $profile $profile $profile $profile $profile $profile

  set prefix (math round\($battery/10\))

  if test $battery_status = Full
      echo "$charging_prefixs[10] | Full Charged!!"
  else if test $battery_status = Discharging
      echo "$discharging_prefixs[$prefix] | Discharging..."
  else if test $battery_status = "Not charging"
      echo "$charging_prefixs[$prefix] | Battery Charged!"
  else
      echo "$charging_prefixs[$prefix] | Charging..."
  end
''
