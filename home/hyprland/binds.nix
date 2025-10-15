{ ... }:
let
  inherit (import ../variables.nix)
    terminal
    ;
in
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Workspace navigation
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"

      # Move windows to workspaces silently
      "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
      
      # Special workspaces
      "$mainMod, C, togglespecialworkspace, chat"
      "$mainMod, O, togglespecialworkspace, obs"

      "$mainMod, D, exec, pypr expose"
      "$mainMod, E, exec, thunar"
      "$mainMod, F, togglefloating,"
      "$mainMod, G, togglegroup"
      "$mainMod SHIFT, L, exec, hyprlock"
      "$mainMod, Q, killactive,"
      "$mainMod, P, pseudo, # dwindle"
      "$mainMod, Return, exec, ${terminal}"
      "$mainMod, S, togglesplit, # dwindle"
      "$mainMod, SPACE, exec, fuzzel"
      "$mainMod SHIFT, Return, exec, fuzzel"
      "$mainMod, TAB, workspace, previous"
      "$mainMod, U, moveoutofgroup"
      "$mainMod, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
      "$mainMod, Y, exec, ykmanoath"
      ",F11,fullscreen"
      "$mainMod, h, movefocus, l"
      "$mainMod, l, movefocus, r"
      "$mainMod, k, movefocus, u"
      "$mainMod, j, movefocus, d"
      "$mainMod ALT, J, changegroupactive, f"
      "$mainMod ALT, K, changegroupactive, b"
      "$mainMod SHIFT, h, movewindoworgroup, l"
      "$mainMod SHIFT, l, movewindoworgroup, r"
      "$mainMod SHIFT, k, movewindoworgroup, u"
      "$mainMod SHIFT, j, movewindoworgroup, d"
      "$mainMod CTRL, h, resizeactive, -60 0"
      "$mainMod CTRL, l, resizeactive,  60 0"
      "$mainMod CTRL, k, resizeactive,  0 -60"
      "$mainMod CTRL, j, resizeactive,  0  60"
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
      "$mainMod, F3, exec, brightnessctl -d *::kbd_backlight set +33%"
      "$mainMod, F2, exec, brightnessctl -d *::kbd_backlight set 33%-"
      ", XF86AudioRaiseVolume, exec, pamixer -i 5 "
      ", XF86AudioLowerVolume, exec, pamixer -d 5 "
      ", XF86AudioMute, exec, pamixer -t"
      ", XF86AudioMicMute, exec, pamixer --default-source -m"
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%- "
      ", XF86MonBrightnessUp, exec, brightnessctl set +5% "
      '', Print, exec, grim -g "$(slurp)" - | swappy -f -''
      "$mainMod, B, exec, pkill -SIGUSR1 waybar"
      "$mainMod, W, exec, pkill -SIGUSR2 waybar"
      "$mainMod, T, exec, ~/.config/scripts/hypr/toggle-touchpad.sh"
    ];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
  };
}
