_: {
  flake.modules.nixos.trackpad = _: {
    # See <https://github.com/Rainblower/Chinese-Trackpad-Archlinux-Hyprland>
    boot.blacklistedKernelModules = ["magicmouse" "hid_magicmouse"];
  };
}
