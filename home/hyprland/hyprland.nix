{
  config,
  lib,
  ...
}:
{
  wayland.windowManager.hyprland = {
    settings = {
      input = {
        repeat_delay = 150;
        repeat_rate = 75;
      };

      general = lib.mkForce {
        gaps_in = 3;
        gaps_out = 8;
        border_size = 3;
        resize_on_border = true;
      };

      layerrule = [
        "blur,waybar"
        "blur,group"
        "blur,launcher"
        "ignorealpha 0.5, launcher"
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
        # Group bar styling (higher opacity for bright wallpaper)
        "col.border_active" = "rgba(ffffffff)"; # White border for active
        "col.border_inactive" = "rgba(3a3a3c80)"; # Your waybar color at 50% opacity
        "col.border_locked_active" = "rgba(f53c3cff)"; # Red for locked (matches your battery critical)
        "col.border_locked_inactive" = "rgba(3a3a3c60)";

        groupbar = {
          enabled = true;
          font_size = 12;
          font_family = "JetBrainsMono Nerd Font Mono";
          font_weight_inactive = "Normal";
          font_weight_active = "Bold";
          height = 16;
          render_titles = true;
          scrolling = true;
          text_color = "rgba(000000dd)";
          indicator_height = 0;
          gradients = true;

          "col.active" = "rgba(ffffffcc)"; # White, 80% opacity
          "col.inactive" = "rgba(ffffff33)"; # White, 20% opacity
          "col.locked_active" = "rgba(f53c3ccc)";
          "col.locked_inactive" = "rgba(ffffff40)";
        };
      };

      exec-once = [
        "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
        "wayvnc 0.0.0.0 -o DP-2"
      ];

    };
  };
}
