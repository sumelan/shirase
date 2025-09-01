{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [inputs.dimland.homeManagerModules.dimland];

  options.custom = {
    dimland.enable =
      lib.mkEnableOption "dimland" // {default = true;};
  };

  config = lib.mkIf config.custom.dimland.enable {
    programs.dimland.enable = true;
  };
}
