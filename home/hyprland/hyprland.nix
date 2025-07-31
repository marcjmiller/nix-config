{ lib, ... }:
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

      exec-once = [
        "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
        "wayvnc 0.0.0.0 -o DP-2"
      ];

    };
  };
}
