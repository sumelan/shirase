_: {
  flake.modules.nixos = {
    steam = _: {
      # To get Steam games working with monado on NixOS,
      # use below as launch options on steam and, if prompted, choose the SteamVR launch option.
      # env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      };
      hardware = {
        graphics.enable32Bit = true;
      };
      custom = {
        persist.home.directories = [".steam"];
        cache.home.directories = [
          ".local/share/Steam"
          ".cache/mesa_shader_cache"
          ".cache/mesa_shader_cache_db"
          ".cache/radv_builtin_shaders"
        ];
      };
    };

    vr = {user, ...}: {
      services.wivrn = {
        enable = true;
        openFirewall = true;

        # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
        # will automatically read this and work with WiVRn (Note: This does not currently
        # apply for games run in Valve's Proton)
        defaultRuntime = true;

        # Run WiVRn as a systemd service on startup
        autoStart = true;

        # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
        config = {
          enable = true;
          json = {
            # 1.0x foveation scaling
            scale = 1.0;
            # 100 Mb/s
            bitrate = 100000000;
            # 10-bit is supported by vaapi encoders using h265 or av1
            bit-depth = 10; # Default value: 8 (bits)
            encoders = [
              {
                # x264: software encoding
                # nvenc: Nvidia hardware encoding
                # vaapi: AMD/Intel hardware encoding
                # vulkan: experimental, for any GPU that supports vulkan video encode
                encoder = "vaapi";
                # One of h264, h265 or av1
                codec = "av1";
                # 1.0 x 1.0 scaling
                width = 1.0;
                height = 1.0;
                offset_x = 0.0;
                offset_y = 0.0;
              }
            ];
          };
        };
      };
      programs.adb.enable = true;
      users.users.${user}.extraGroups = ["adbusers"];

      custom.persist = {
        home.directories = [
          ".config/wivrn"
        ];
      };
    };
  };
}
