{lib, ...}: let
  inherit (lib) splitString;
in {
  spawn = cmd: splitString " " cmd;
  spawn-sh = cmd: ["sh" "-c" cmd];

  hotkey = {
    color,
    name,
    text,
  }: ''<span foreground="${color}">[${name}]</span> ${text}'';
}
