{ ... }:
let
  inherit (import ../variables.nix)
    terminal
    ;
in
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Named workspace navigation
      "$mainMod, C, workspace, name:chat"
      "$mainMod, D, workspace, name:dev"
      "$mainMod, O, workspace, name:obs"

      # Move windows to named workspaces
      "$mainMod SHIFT, C, movetoworkspace, name:chat"
      "$mainMod SHIFT, D, movetoworkspace, name:dev"
      "$mainMod SHIFT, O, movetoworkspace, name:obs"      

      "$mainMod, E, exec, thunar"
      "$mainMod, F, togglefloating,"
      "$mainMod, G, togglegroup"
      "$mainMod, Q, killactive,"
      "$mainMod, P, pseudo, # dwindle"
      "$mainMod, Return, exec, ${terminal}"
      "$mainMod, S, togglesplit, # dwindle"
      "$mainMod, SPACE, exec, fuzzel"
      "$mainMod, TAB, workspace, previous"
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
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
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
    ];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
  };
}
