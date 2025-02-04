{ inputs, ... }:
{
  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  programs.nixcord = {
    enable = true;  # enable Nixcord. Also installs discord package
    config = {
      frameless = true; # set some Vencord options
      plugins = {
        # Some plugin here
        # ...
        };
      };
    extraConfig = {
      # Some extra JSON config here
      # ...
    };
  # ...
  };
}
