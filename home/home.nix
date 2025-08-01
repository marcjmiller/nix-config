{
  config,
  lib,
  pkgs,
  ...
}:
let
  braveThemePath = "${config.home.homeDirectory}/.local/share/brave-theme";
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
    bluez
    bluez-tools
    dive
    eza
    fzf
    gimp
    go
    httpie
    networkmanagerapplet
    nodejs_24
    openssl
    psmisc
    pulumi-bin
    sops
    stern
    twofctl
    typescript
    wayvnc
    yq-go
    pcsc-tools
    (pkgs.writeShellScriptBin "setup-browser-CAC" ''
      NSSDB="''${HOME}/.pki/nssdb"
      mkdir -p ''${NSSDB}

      ${pkgs.nssTools}/bin/modutil -force -dbdir sql:$NSSDB -add yubi-smartcard \
        -libfile ${pkgs.opensc}/lib/opensc-pkcs11.so
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
    # Add packages from home Manager that you want
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
        "--load-extensions=${braveThemePath}"
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

  services.hyprpaper = {
    enable = true;
    settings.preload = [
      "~/Pictures/Wallpapers/${desktopImage}"
    ];
    settings.wallpaper = [
      ",~/Pictures/Wallpapers/${desktopImage}"
    ];
  };
}
