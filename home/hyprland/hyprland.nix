{
  config,
  lib,
  ...
}:
let
  base00 = "#${config.lib.stylix.colors.base00}";
  base08 = "#${config.lib.stylix.colors.base08}";
  inherit (import ../variables.nix)
    laptopMonitor
    mainMonitor
    ;
in
{
  wayland.windowManager.hyprland = {
    settings = {
      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
      ];
      input = {
        repeat_delay = 200;
        repeat_rate = 75;
        touchpad = {
          natural_scroll = lib.mkForce true;
          disable_while_typing = true;
          clickfinger_behavior = true;
        };
      };

      general = lib.mkForce {
        gaps_in = 3;
        gaps_out = 8;
        border_size = 3;
        resize_on_border = true;
      };

      workspace = [
        "name:chat, monitor:${mainMonitor}"
        "name:dev, monitor:${mainMonitor}"
        "name:1, monitor:${mainMonitor}"
        "name:2, monitor:${mainMonitor}"
        "name:3, monitor:${mainMonitor}"
        "name:lp, monitor:${laptopMonitor}"
        "name:obs, monitor:${mainMonitor}"
        "special:exposed,gapsout:60,gapsin:30,bordersize:5,border:true,shadow:false"
      ];

      layerrule = [
        "blur,waybar"
        "blur,group"
        "blur,launcher"
        "ignorealpha 0.5, launcher"
      ];

      windowrulev2 = [
        # Chat
        "workspace 4, class:^(?i)discord$"
        "workspace 4, class:^(?i)slack$"

        # Dev
        "workspace 5, class:^(?i)code$"
        "workspace 5, class:^(?i)dev\.zed\.zed$"

        # OBS
        "workspace 6, class:^(?i)com\.obsproject\.studio"
      ];

      decoration = {
        blur = lib.mkForce {
          enabled = true;
          new_optimizations = true;
          xray = false;
          popups = true;
        };
      };

      group = lib.mkForce {
        groupbar = {
          enabled = true;
          font_size = 16;
          font_family = "JetBrainsMono Nerd Font Mono";
          font_weight_inactive = "Normal";
          font_weight_active = "Bold";
          height = 20;
          render_titles = true;
          scrolling = true;
          text_color = builtins.replaceStrings [ "#" ] [ "rgba(" ] base08 + "ee)";
          indicator_height = 0;
          gradients = true;

          "col.active" = builtins.replaceStrings [ "#" ] [ "rgba(" ] base00 + "dd)";
          "col.inactive" = builtins.replaceStrings [ "#" ] [ "rgba(" ] base00 + "55)";
          "col.locked_active" = builtins.replaceStrings [ "#" ] [ "rgba(" ] base00 + "dd)";
          "col.locked_inactive" = builtins.replaceStrings [ "#" ] [ "rgba(" ] base00 + "55)";
        };
      };

      exec-once = [
        "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
        "udiskie"
        "~/.config/scripts/hypr/toggle-touchpad.sh"
        "/usr/local/bin/pypr --debug /tmp/pypr.log"

        # Start chat apps on chat workspace
        "[workspace 4 silent] slack"

        # Start code editor on code workspace
        "[workspace 5 silent] zed"
        "[workspace 5 silent] kitty"

        # Start OBS on obs workspace
        "[workspace 6 silent] obs-studio"
      ];

      # Monitor configuration events
      # bindl = [
      #   ",monitoradded,*,~/.config/scripts/hypr/toggle-touchpad.sh"
      #   ",monitorremoved,*,~/.config/scripts/hypr/toggle-touchpad.sh"
      # ];
    };

    # extraConfig = ''
    #   device {
    #     name = "yowkees-keyball61-consumer-control-1";
    #     defaultSpeed = 2;
    #   }
    #   device {
    #     name = "yowkees-keyball61-mouse";
    #     defaultSpeed = 2;
    #   }
    # '';
  };
}
