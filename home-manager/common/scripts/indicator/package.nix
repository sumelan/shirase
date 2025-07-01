{
  lib,
  pkgs,
  ...
}:
pkgs.writers.writeFishBin "write_recorder_state" ''
  function is_recorder_running
      ${lib.getExe' pkgs.procps "pgrep"} -x "wf-recorder" > /dev/null
  end

  function is_convert_processing
      ${lib.getExe' pkgs.procps "pgrep"} -x "ffmpeg" > /dev/null
  end

  if is_recorder_running
      echo " | Recording..."
  else if is_convert_processing
      echo " | Converting..."
  end
''
