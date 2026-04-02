[
  {
    key = "w";
    desc = "Select a window as the dynamic cast target";
    cmd = "niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)";
  }
  {
    key = "o";
    desc = "Set the dynamic cast target to the focused monitor";
    cmd = "niri msg action set-dynamic-cast-monitor";
  }
  {
    key = "c";
    desc = "Clear the dynamic cast target";
    cmd = "niri msg action clear-dynamic-cast-target";
  }
]
