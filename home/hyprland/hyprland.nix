{
  config,
  lib,
  ...
}:
let
  base00 = "#${config.lib.stylix.colors.base00}";
  base08 = "#${config.lib.stylix.colors.base08}";
  inherit (import ../variables.nix)
    mainMonitor
    ;
in
{
  wayland.windowManager.hyprland = {
    settings = {
      input = {
        repeat_delay = 200;
        repeat_rate = 75;
      };

      general = lib.mkForce {
        gaps_in = 3;
        gaps_out = 8;
        border_size = 3;
        resize_on_border = true;
      };

      workspace = [
        "name:chat, monitor:${mainMonitor}"
        "name:code, monitor:${mainMonitor}"
      ];

      layerrule = [
        "blur,waybar"
        "blur,group"
        "blur,launcher"
        "ignorealpha 0.5, launcher"
      ];

      windowrulev2 = [
        # Chat applications
        "workspace name:chat, class:^(discord)$"
        "workspace name:chat, class:^(Discord)$"
        "workspace name:chat, class:^(Slack)$"
        "workspace name:chat, class:^(slack)$"

        # Code applications
        "workspace name:code, class:^(code)$"
        "workspace name:code, class:^(Code)$"
        "workspace name:code, class:^(zed)$"
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

        # Start chat apps on chat workspace
        "[workspace name:chat silent] discord"
        "[workspace name:chat silent] slack"

        # Start code editor on code workspace
        "[workspace name:code silent] zed"
        "[workspace name:code silent] kitty"
      ];

    };
  };
}
