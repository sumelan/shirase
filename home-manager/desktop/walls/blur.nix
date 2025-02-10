{
  lib,
  config,
  pkgs,
  user,
  ...
}:
let
  niri-blur-wallpaper = pkgs.writers.writePython3Bin "niri-blur-wallpaper" {doCheck = false;} ''
    import os
    import subprocess
    import json
    wallpapers_path = "/home/${user}/Pictures/Wallpapers/"
    wallpapers_cache_path = "/home/${user}/.cache/swww/"
    events_of_interest = ["Workspace focused", "Window opened", "Window closed"]
    def get_niri_msg_output(msg):
        output = subprocess.check_output(["niri", "msg", "-j", msg])
        output = json.loads(output)
        return output
    def get_current_wallpaper(monitor):
        with open(os.path.join(wallpapers_cache_path, monitor)) as f:
            wallpaper = str(f.read())
            return wallpaper
    def set_wallpaper(monitor, wallpaper):
        print(wallpaper)
        subprocess.run(
            [
                "swww",
                "img",
                "--transition-type",
                "fade",
                "--transition-duration",
                "0.5",
                "-o",
                monitor,
                wallpaper,
            ]
        )
    def change_wallpaper_on_event():
        workspaces = get_niri_msg_output("workspaces")
        active_workspaces = [
            workspace for workspace in workspaces if workspace["is_active"]
        ]
        for active_workspace in active_workspaces:
            active_workspace_is_empty = active_workspace["active_window_id"] is None
            active_workspace_monitor = active_workspace["output"]
            current_wallpaper_is_blurred = "blurred" in get_current_wallpaper(
                active_workspace_monitor
            )
            if active_workspace_is_empty:
                if not current_wallpaper_is_blurred:
                    continue
                wallpaper = os.path.join(wallpapers_path, f"{active_workspace_monitor}.jpg")
            else:
                if current_wallpaper_is_blurred:
                    continue
                wallpaper = os.path.join(
                    wallpapers_path, f"{active_workspace_monitor}-blurred.jpg"
                )
            set_wallpaper(active_workspace_monitor, wallpaper)
    def main():
        event_stream = subprocess.Popen(
            ["niri", "msg", "event-stream"], stdout=subprocess.PIPE
        )
        for line in iter(event_stream.stdout.readline, ""):
            if any(event in line.decode() for event in events_of_interest):
                change_wallpaper_on_event()
    if __name__ == "__main__":
        main()
  '';
in
lib.mkIf config.custom.niri.enable {
  programs.niri.settings.spawn-at-startup = [
    {command = ["${niri-blur-wallpaper}/bin/niri-blur-wallpaper"];
  }];
}

