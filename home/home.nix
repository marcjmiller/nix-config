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
    meld
    networkmanagerapplet
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
      enable = true;
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
