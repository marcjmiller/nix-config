{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
    ../../home/falcon.nix
  ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        21
        80
        443
        5900
      ];
    };

    networkmanager = {
      enable = true;
      plugins = [
        pkgs.networkmanager-openvpn
      ];
    };
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

  powerManagement = {
    enable = true;
  };

  services.tlp = {
    enable = true;

    settings = {
      # CPU scaling governors
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # CPU performance scaling (for Intel)
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Wi-Fi power management
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # Optional: Disk power management
      DISK_IDLE_SECS_ON_AC = 0;
      DISK_IDLE_SECS_ON_BAT = 2;
    };
  };

  # Enforce password complexity requirements
  environment.etc."/security/pwquality.conf".text = ''
    # Minimum password length
    minlen = 12

    # Require at least one digit
    dcredit = -1

    # Require at least one uppercase letter
    ucredit = -1

    # Require at least one lowercase letter
    lcredit = -1

    # Require at least one special character
    ocredit = -1

    # Require at least six different characters
    difok = 6

    # Enforce for root user
    enforce_for_root = true
  '';

  users.users.marcmiller = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Marc Miller";
    extraGroups = [
      "bluetooth"
      "docker"
      "input"
      "kvm"
      "libvirtd"
      "networkmanager"
      "qemu-libvirtd"
      "wheel"
    ];
  };

  system.stateVersion = "24.05";
}
