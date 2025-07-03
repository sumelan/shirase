_: {
  mkSymlinks =
    { dest, src }:
    {
      systemd.tmpfiles.rules = [ "L+ ${dest} - - - - ${src}" ];
    };
}
