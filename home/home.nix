{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ./variables.nix)
    desktopImage
    mainMonitor
    ;
in
with lib;
{
  imports = [
    ./brave.nix
    ./firefox.nix
    ./hyprland
    ./waybar
    ./zed.nix
    ./zsh.nix
  ];

  secondfront.hyprland.monitors = [
    # Setup your monitors
    {
      name = "eDP-1";
      position = "auto";
      height = 1200;
      width = 1920;
      refreshRate = 60;
    }
    {
      name = mainMonitor;
      width = 3840;
      height = 2160;
      refreshRate = 144;
      position = "auto-left";
    }
  ];

  home.packages = with pkgs; [
    age
    appgate-sdp
    bat
    bluez
    bluez-tools
    dive
    eza
    file-roller
    fzf
    gimp
    go
    httpie
    httpie-desktop
    libnotify
    libpwquality
    meld
    networkmanagerapplet
    networkmanager-openvpn
    nodejs_24
    noto-fonts
    openssl
    papirus-icon-theme
    psmisc
    pulumi-bin
    inputs.pyprland.packages.${pkgs.system}.default
    rust-analyzer
    sops
    stern
    twofctl
    typescript
    unzip
    usbutils
    vial
    wayvnc
    xfce.catfish
    yazi
    yq-go
    pcsc-tools

    # User-defined functions
    (writeShellScriptBin "setup-browser-CAC" ''
      NSSDB="''${HOME}/.pki/nssdb"
      mkdir -p ''${NSSDB}

      ${pkgs.nssTools}/bin/modutil -force -dbdir sql:$NSSDB -add yubi-smartcard \
        -libfile ${pkgs.opensc}/lib/opensc-pkcs11.so
    '')

    (writeShellScriptBin "eks-update-cidrs" ''
      ${builtins.readFile ./files/bin/eks-update-cidrs}
    '')
  ];

  home.file = {
    ".gitmessage" = {
      source = ./files/gitmessage;
    };
    ".config/scripts" = {
      source = ./files/scripts;
      recursive = true;
    };
    ".config/hypr/pyprland.toml" = {
      source = ./files/pyprland.toml;
    };
    "Pictures/Wallpapers" = {
      source = ./files/wallpapers;
      recursive = true;
    };
    "Pictures/OBS" = {
      source = ./files/obs;
      recursive = true;
    };
  };

  secondfront.themes.enable = false;

  stylix = {
    enable = true;
    image = lib.mkForce ./files/wallpapers/${desktopImage};
    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    opacity = {
      terminal = lib.mkForce 0.9;
      desktop = lib.mkForce 0.9;
      popups = lib.mkForce 0.9;
    };

    targets.fuzzel.enable = true;
    targets.k9s.enable = true;
    targets.kitty.enable = true;
  };

  home.activation.generateBraveTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -f ~/.config/stylix/generated.json ]; then
      echo "🔧 Generating Brave theme from Stylix..."
      # ${pkgs.bash}/bin/bash ~/.config/scripts/brave/gen-brave-theme.sh
    fi
  '';

  programs = {
    obs-studio.enable = true;

    kitty = {
      settings = {
        copy_on_select = "yes";
        scrollback_lines = 10000;
      };
    };

    chromium = {
      enable = false;
      package = pkgs.brave;
      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Darkreader
        { id = "acacmjcicejlmjcheoklfdchempahoag"; } # JSON Lite
        { id = "fmkadmapgofadopljbjfkapdkoienihi"; } # React Dev Tools
        { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # Stylix
        { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # Tampermonkey
        { id = "cigimgkncpailblodniinggablglmebn"; } # Stylix-generated Theme
      ];
      commandLineArgs = [
        "--force-dark-mode"
        "--enable-features=WebUIDarkMode"
        "--disable-features=AutofillSavePaymentMethods,AutofillCreditCardAuthentication,AutofillCreditCardUpload"
        "--disable-features=AutofillSaveCardDialog,AutofillEnableAccountWalletStorage,AutofillCreditCardDownstream"
        "--password-store=basic"
        "--disable-save-password-bubble"
        "--disable-autofill-keyboard-accessory-view"
        "--wallet-service-use-sandbox"
      ];
    };

    fuzzel = {
      enable = true;
      settings = {
        main = {
          prompt = "\"󰍉 \"";
        };
        border = {
          radius = 8;
        };
      };
    };

    tealdeer = {
      enable = true;
      settings = {
        display.compact = false;
        display.use_pager = true;
        updates.auto_update = true;
      };
    };
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        };

        listener = [
          {
            timeout = 150; # 2.5min - dim the screen
            on-timeout = "${pkgs.brightnessctl} -s set 10";
            on-resume = "${pkgs.brightnessctl} -r";
          }
          {
            timeout = 300; # 5 minutes - lock the screen
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 600; # 10 minutes - turn off displays
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on && ${pkgs.brightnessctl} -r";
          }
          {
            timeout = 1200; # 20 minutes - suspend system
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };

    hyprpaper = {
      enable = true;
      settings.preload = [
        "~/Pictures/Wallpapers/${desktopImage}"
      ];
      settings.wallpaper = [
        ",~/Pictures/Wallpapers/${desktopImage}"
      ];
    };

    kanshi = {
      enable = true;
      settings = [
        {
          profile = {
            name = "default";
            outputs = [
              {
                criteria = "eDP-1";
                status = "enable";
                position = "0,0";
                mode = "1920x1200";
              }
            ];
          };
        }
        {
          profile = {
            name = "home_office";
            outputs = [
              {
                criteria = "eDP-1";
                status = "disable";
              }
              {
                criteria = "DP-2";
                position = "0,0";
                mode = "3840x2160@144";
              }
            ];
          };
        }
      ];
    };
    
    network-manager-applet = {
      enable = true;
    };

    udiskie.enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "x-terminal-emulator" = "kitty.desktop";
      "text/html" = "firefox.desktop";
      "image/jpeg" = "firefox.desktop";
      "image/png" = "firefox.desktop";
    };
  };
}
