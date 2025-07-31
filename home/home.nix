{
  pkgs,
  lib,
  ...
}:
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
  ];

  home.packages = with pkgs; [
    bluez
    bluez-tools
    gimp
    go
    httpie
    networkmanagerapplet
    nodejs_24
    openssl
    pulumi-bin
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
    ".config/scripts" = {
      source = ./files/scripts;
      recursive = true;
    };
    "Pictures/Wallpapers" = {
      source = ./files/wallpapers;
      recursive = true;
    };
  };

  secondfront.themes.enable = false;

  stylix = {
    enable = true;
    image = lib.mkForce ./files/wallpapers/rainnight.jpg;
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
  };

  programs = {
    # Add packages from home Manager that you want
    obs-studio.enable = true;

    kitty = {
      settings = {
        copy_on_select = "yes";
        scrollback_lines = 10000;
      };
      themeFile = "Catppuccin-Mocha";
      extraConfig = lib.mkForce "";
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
      ];
      commandLineArgs = [
        "--disable-features=AutofillSavePaymentMethods"
      ];
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
      "~/Pictures/Wallpapers/rainnight.jpg"
    ];
    settings.wallpaper = [
      ",~/Pictures/Wallpapers/rainnight.jpg"
    ];
  };
}
