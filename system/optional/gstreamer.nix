{
  lib,
  config,
  pkgs,
  ...
}: {
  options.custom = {
    gstreamer.enable = lib.mkEnableOption "Gstreamer";
  };

  config = lib.mkIf config.custom.gstreamer.enable {
    environment.systemPackages = [
      pkgs.openssl
      pkgs.glib
      pkgs.gst_all_1.gstreamer
      pkgs.gst_all_1.gst-plugins-base
      pkgs.gst_all_1.gst-plugins-good
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-plugins-ugly
      pkgs.gst_all_1.gst-libav
      pkgs.gst_all_1.gst-vaapi
    ];

    environment.variables = {
      LD_LIBRARY_PATH = lib.mkForce "${
        lib.makeSearchPathOutput "lib" "lib" [
          pkgs.openssl
          pkgs.glib
        ]
      }:$LD_LIBRARY_PATH";

      GST_PLUGIN_SYSTEM_PATH_1_0 = "${
        lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
          pkgs.gst_all_1.gstreamer
          pkgs.gst_all_1.gst-plugins-base
          pkgs.gst_all_1.gst-plugins-good
          pkgs.gst_all_1.gst-plugins-bad
          pkgs.gst_all_1.gst-plugins-ugly
          pkgs.gst_all_1.gst-libav
          pkgs.gst_all_1.gst-vaapi
        ]
      }:$GST_PLUGIN_SYSTEM_PATH_1_0";
    };
  };
}
