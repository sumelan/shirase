{
  pkgs,
  ghosttyConfig,
}:
pkgs.writeText "wrapped-ghostty.service" ''
  [D-BUS Service]
  Name=com.mitchellh.ghostty
  SystemdService=app-com.mitchellh.ghostty.service
  Exec=${pkgs.lib.getExe pkgs.ghostty} --config-default-files=false --config-file=${ghosttyConfig} --gtk-single-instance=true --initial-window=false
''
