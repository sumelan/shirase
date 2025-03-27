#!/usr/bin/env nu

def main [action: string] {
    if ($action | str contains "member=open") {
        let monitor = (get_current_monitor_id)
        (eww open --config . dashboard_monitor --screen $monitor)
    } else {
        (eww close --config . dashboard_monitor)
    }
}

def get_current_wm [] {
    $env.XDG_CURRENT_DESKTOP
}

def get_current_monitor_id [] {
    let wm = (get_current_wm)
    match $wm {
        'niri' => { (niri msg --json focused-output | from json | get name) }
    }
}
