{pkgs, ...}: let
  inherit (pkgs.lib) genAttrs;
in {
  services.keyd = {
    enable = true;
    keyboards.default = let
      lockKeys = [
        "esc"
        "f1"
        "f2"
        "f3"
        "f4"
        "f5"
        "f6"
        "f7"
        "f8"
        "f9"
        "f10"
        "f11"
        "f12"
        "grave"
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
        "0"
        "minus"
        "equal"
        "backspace"
        "tab"
        "q"
        "w"
        "e"
        "r"
        "t"
        "y"
        "u"
        "i"
        "o"
        "p"
        "leftbrace"
        "rightbrace"
        "backslash"
        "leftmeta"
        "a"
        "s"
        "d"
        "f"
        "g"
        "h"
        "j"
        "k"
        "l"
        "semicolon"
        "apostrophe"
        "enter"
        "leftshift"
        "z"
        "x"
        "c"
        "v"
        "b"
        "n"
        "m"
        "comma"
        "dot"
        "slash"
        "rightshift"
        "leftcontrol"
        "leftalt"
        "space"
        "rightalt"
        "rightcontrol"
        "up"
        "down"
        "left"
        "right"
        "home"
        "end"
        "pageup"
        "pagedown"
        "insert"
        "delete"
        "print"
        "sysrq"
        "scrolllock"
        "pause"
        "menu"
      ];
      lockLayer =
        (genAttrs lockKeys (_: "noop"))
        // {
          capslock = "toggle(lock)"; # push `CapsLock` to resolve the locking-state
        };
    in {
      ids = ["*"];
      settings = {
        shift = {
          capslock = "toggle(lock)"; # `Shift+CapsLock` to lock/unlock keyboard
        };
        lock = lockLayer;
        global = {
          layer_indicator = "1"; # CapsLock LED
        };
      };
    };
  };

  # perm-rejection
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
