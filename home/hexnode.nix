{ pkgs, ... }:
let
  hexnode = pkgs.callPackage ./hexnode { };
in
{
  systemd.services.hexnode-agent = {
    enable = true;
    description = "Hexnode Linux Agent Service";
    unitConfig.DefaultDependencies = false;
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${hexnode}/bin/ha-bash -c \"${hexnode}/bin/hexnode_agent\"";
      Type = "forking";
      PIDFile = "/run/hexnoded.pid";
      Restart = "on-failure";
      TimeoutStopSec = "60s";
      KillMode = "process";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
