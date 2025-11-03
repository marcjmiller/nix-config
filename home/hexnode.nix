{ pkgs, ... }:
let
  hexnode = pkgs.callPackage ./hexnode { };

  # This script will launch the agent. Using a separate script allows us
  # to add logging and makes the ExecStart line cleaner.
  startScript = pkgs.writeShellScript "start-hexnode.sh" ''
    #!${pkgs.stdenv.shell}
    set -x # Enables debug printing for the script
    echo "Attempting to start hexnode_agent inside FHS environment..."
    
    # Using exec is important, it replaces the shell process with the agent's launcher
    # exec ${hexnode}/bin/ha-bash -c "hexnode_agent"
    # Run the FHS environment and bind-mount /var/lib → /etc
    exec ${hexnode}/bin/ha-bash -c "
      mkdir -p /etc/hexnode_agent
      mount --bind /var/lib/hexnode_agent /etc/hexnode_agent || true
      mount --bind /sys /sys || true
      mount --bind /proc /proc || true
      mount --bind /run/dbus/system_bus_socket /run/dbus/system_bus_socket || true
      mount --bind /var/lib/NetworkManager /var/lib/NetworkManager || true
      mount --bind /var/run /var/run || true
      /usr/bin/hexnode_agent
    "
  '';
in
{
  systemd.tmpfiles.rules = [
    "d /var/lib/hexnode_agent 0755 root root -"
  ];
  
  systemd.services.hexnode-agent = {
    enable = true;
    description = "Hexnode Linux Agent Service";
    unitConfig.DefaultDependencies = false;
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${startScript}";

      Type = "forking";
      PIDFile = "/run/hexnoded.pid";
      Restart = "on-failure";
      TimeoutStopSec = "60s";
      KillMode = "process";

      # This is the key for debugging. It sends all output from the service
      # (including the 'echo' and 'set -x' from startScript) to the system journal.
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };
}
