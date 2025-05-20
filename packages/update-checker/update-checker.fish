#!/usr/bin/env fish

# NixOS Update Checker for Waybar
# This script checks for NixOS updates and outputs JSON for Waybar integration

# ===== Configuration =====
set UPDATE_INTERVAL 3599  # Check interval in seconds (1 hour)
set NIXOS_CONFIG_PATH "$HOME/projects/wolborg"  # Path to NixOS configuration
set CACHE_DIR "$HOME/.cache/update-checker"
set STATE_FILE "$CACHE_DIR/nix-update-state"
set LAST_RUN_FILE "$CACHE_DIR/nix-update-last-run"
set LAST_RUN_TOOLTIP "$CACHE_DIR/nix-update-tooltip"

# If you have a separate script to update your lock file (i.e. "nix flake update" script)
# and you have UPDATE_LOCK_FILE set to "false",
# the UPDATE_FLAG will signal that your lock file has been updated.
# Add the following to your update script so that the output of nvd diff is piped in:
# | tee >(if grep -qe '\\[U'; then touch \"$HOME/.cache/nix-update-update-flag\"; else rm -f \"$HOME/.cache/nix-update-update-flag\"; fi) &&
set UPDATE_FLAG "$CACHE_DIR/nix-update-update-flag"

# The REBUILD_FLAG signals this script to run after your system has been rebuilt.
# Add this to your update script:
# && touch $HOME/.cache/nix-update-rebuild-flag && pkill -x -RTMIN+12 .waybar-wrapped
set REBUILD_FLAG "$CACHE_DIR/nix-update-rebuild-flag"


# ===== Initialize Files =====
function init_files
    # Create the state file if it doesn't exist
    if [ ! -f "$STATE_FILE" ]
        echo "0" > "$STATE_FILE"
    end

  # Create the last run file if it doesn't exist
    if [ ! -f "$LAST_RUN_FILE" ]
        echo "0" > "$LAST_RUN_FILE"
    end

  # Create the tooltip file if it doesn't exist
    if [ ! -f "$LAST_RUN_TOOLTIP" ]
        set updates (cat "$STATE_FILE")
        if test $updates -eq 0
            echo "System updated" > "$LAST_RUN_TOOLTIP"
        else
            # Will be populated during update check
            echo "" > "$LAST_RUN_TOOLTIP"
        end
    end
end

# ===== Helper Functions =====
function send_notification -a 1 2
    set --local title "$1"
    set --local message "$2"
    notify-send "$title" "$message" -e
end

function check_network_connectivity
    # Check if either ethernet or wireless is connected
    if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1
        return 0  # Connected to the internet
    else
        return 1  # Not connected to the internet
    end
end

function sys_updated
    if [ -f "$REBUILD_FLAG" ]
        return 0 # System has been updated
    else
        return 1 # System has not been updated
    end
end

function calc_next_update
    set --local last_run (cat "$LAST_RUN_FILE")
    set --local current_time (date +%s)
    set --local next_update (math $UPDATE_INTERVAL - (math $current_time - $last_run))
    set --local next_update_min (math --scale 0 $next_update / 60)
    echo "$next_update_min"
end

function var_setter
    if test $updates -ne 0
        set --global alt "has-updates"
        set --global tooltip (cat "$LAST_RUN_TOOLTIP")
    else
        set --global alt "updated"
        set --global tooltip "System updated"
    end
end

# ===== Update Check Logic =====
function check_for_updates
    set --local tempdir (mktemp -d)
    # Ensure cleanup happens when script exits
    trap "rm -rf '$tempdir'" EXIT

    send_notification "Checking for Updates" "Please be patient"

    set --local updates 0
    set --local tooltip ""

        # Use the config directory directly
    cd "$NIXOS_CONFIG_PATH" || return 1
    set updates (nh os switch --dry --update | grep -e '\[U.]' | wc -l)
    set tooltip (nh os switch --dry --update | grep -e '\[U.]' | awk '{ for (i=3; i<NF; i++) printf $i " "; if (NF >= 3) print $NF; }' ORS='\\n')

    # Save results
    echo "$updates" > "$STATE_FILE"
    echo "$(date +%s)" > "$LAST_RUN_FILE"

    if test $updates = 0
        echo "System updated" > "$LAST_RUN_TOOLTIP"
        send_notification "Update Check Complete" "No updates available"
    else if [ "$updates" -eq 1 ]
        echo "$tooltip" > "$LAST_RUN_TOOLTIP"
        send_notification "Update Check Complete" "Found 1 update"
    else
        echo "$tooltip" > "$LAST_RUN_TOOLTIP"
        send_notification "Update Check Complete" "Found $updates updates"
    end

    return 0
end

# ===== Main Function =====
function main
    init_files

    # Check for network connectivity before proceeding
    if check_network_connectivity

      set --local updates 0
      set --local alt ""
      set --local tooltip ""

      # Delete flags if system was just updated
      if sys_updated
          set updates 0
          set alt "updated"
          set tooltip "System updated"
          echo "$updates" > "$STATE_FILE"
          echo "$tooltip" > "$LAST_RUN_TOOLTIP"
          if [ -f $UPDATE_FLAG ]
              rm "$UPDATE_FLAG"
          end
          rm "$REBUILD_FLAG"
      else
          # Read state from files
          set --global updates (cat "$STATE_FILE")
          set --global last_run (cat "$LAST_RUN_FILE")
          set --global current_time (date +%s)

          # Decide whether to show saved state or perform new check
          if [ $(math $current_time - $last_run) -gt "$UPDATE_INTERVAL" ]
              # Time to check for updates
              if check_for_updates
                  set updates (cat "$STATE_FILE")
                  var_setter
              else
                  # Update check failed
                  set alt "error"
                  set tooltip "Update check failed"
              end
          else
              # Use saved state
              send_notification "Please Wait" "Next update is in $(calc_next_update) min."
              var_setter
          end
      end
    else
        set updates (cat "$STATE_FILE")
        var_setter
        send_notification "Update Check Failed" "Not connected to the internet"
    end

    # Output JSON for Waybar
    echo "{ \"text\":\"$updates\", \"alt\":\"$alt\", \"tooltip\":\"$tooltip\" }"
end


# Execute main function
main

