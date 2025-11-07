{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.hexnode;
  hexnodePkg = pkgs.callPackage ./hexnode.nix { };
in
{
  options.services.hexnode = {
    enable = mkEnableOption "Hexnode MDM Agent";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ hexnodePkg ];

    environment.etc."hexnode_agent" = {
      source = "/var/lib/hexnode_agent";
    };

    systemd.services.hexnode_agent = {
      description = "Hexnode Linux Agent Service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${hexnodePkg}/usr/local/bin/hexnode_agent";
        StandardOutput = "journal";
        StandardError = "journal";
        SyslogIdentifier = "hexnode_agent";
        Restart = "always";
        RestartSec = "5s";
        User = "root";
        Group = "root";
      };
      preStart = ''
        if [ ! -f /var/lib/hexnode_agent/config.enc ];
        then
          cp -r ${hexnodePkg}/etc/hexnode_agent/. /var/lib/hexnode_agent/
        fi
      '';
    };
  };
}
