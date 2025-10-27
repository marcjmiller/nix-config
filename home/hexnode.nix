{ pkgs, ... }:
let
  hexnode = pkgs.callPackage ./home/hexnode { };
in
{
  systemd.services.hexnode = {
    enable = true;
    description = "Hexnode UEM Agent";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${hexnode}/bin/hexnode-config";
      Restart = "on-failure";
    };
  };
}
