_: {
  imports = [
    ../../modules/nixos/game/steam.nix
    ../../modules/nixos/hardware/trackpad.nix
    ../../modules/nixos/hardware/qmk.nix
    ../../modules/nixos/services/syncoid.nix
  ];

  networking.hostId = "8425e349";

  custom = {
    wayland.windowManager.niri = {
      extraBinds = {
        "XF86MonBrightnessUp" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "call" "brightness" "increment" "5%" "software:DP-1"];
        };
        "XF86MonBrightnessDown" = {
          _props.allow-when-locked = true;
          spawn = ["dms" "ipc" "call" "brightness" "decrement" "5%" "software:DP-1"];
        };
      };

      xwayland = true;
    };

    programs = {
      ssh.extraConfig = ''
        Host syncoid
          HostName 192.168.68.62
          Port 22

        Host sakura-initrd
          HostName 192.168.68.62
          Port 2222
          User root
          IdentitiesOnly yes
          IdentityFile /root/.ssh/initrd_ssh_ed25519_key
      '';

      btop.cudaSupport = true;
    };
  };
}
