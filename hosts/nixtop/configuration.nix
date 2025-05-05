{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 21 80 443 5900 ];
  };

  modules = {
    hostName = "nixtop";
    peripherals = {
      enable = true;
      obs.enable = true;
      scarlettRite.enable = true;
    };
  };

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.font-awesome
  ];

  system.stateVersion = "24.05";
}
