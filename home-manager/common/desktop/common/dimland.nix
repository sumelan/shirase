{inputs, ...}: {
  imports = [inputs.dimland.homeManagerModules.dimland];

  programs.dimland.enable = true;
}
