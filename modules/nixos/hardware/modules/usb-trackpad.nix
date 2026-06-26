_: {
  flake.modules.nixos.usb-trackpad = _: {
    boot.kernelParams = ["psmouse.synaptics_intertouch=0"];
  };
}
