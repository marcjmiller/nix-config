{
  config,
  lib,
  pkgs,
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
      # Check logs with: bat $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/hyprland.log
      # debug = {
      #   disable_logs = false;
      # };
      
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
        "name:1, monitor:${mainMonitor}"
        "name:2, monitor:${mainMonitor}"
        "name:3, monitor:${mainMonitor}"
        "name:4, monitor:${mainMonitor}"
        "name:lp, monitor:${laptopMonitor}"
        "special:exposed,gapsout:60,gapsin:30,bordersize:5,border:true,shadow:false"
        "special:obs"
        "special:chat"
      ];

      layerrule = [
        "blur,waybar"
        "blur,group"
        "blur,launcher"
        "ignorealpha 0.5, launcher"
      ];

      windowrulev2 = [
        # Chat
        "workspace special:chat, class:^(discord)$"
        "workspace special:chat, class:^(slack)$"

        # OBS
        "workspace special:obs, class:^(com.obsproject.Studio)$"
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
          font_family = "JetBrainsMono Nerd Font Propo";
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
        "/home/marcmiller/.nix-profile/bin/pypr --debug /tmp/pypr.log"
        "${pkgs.hypridle}/bin/hypridle"

        # Start chat apps on chat workspace
        "[workspace special:chat silent] ${pkgs.slack}/bin/slack"

        # Start code editor on code workspace
        "[workspace 4 silent] ${pkgs.zed-editor}/bin/zed-editor"
        "[workspace 4 silent] ${pkgs.kitty}/bin/kitty"

        # Start OBS on obs workspace
        "[workspace special:obs silent] ${pkgs.obs-studio}/bin/obs-studio"
      ];
    };
  };
}
