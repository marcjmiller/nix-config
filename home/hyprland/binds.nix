{ ... }:
let
  inherit (import ../variables.nix)
  apps
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
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
      "$mainMod, TAB, workspace, previous"

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
      
      # Pypr commands
      "$mainMod, D, exec, pypr expose" # Expose view
      "$mainMod SHIFT, V, exec, pypr toggle volume" # Toggle terminal
      "$mainMod SHIFT, W, exec, pypr fetch_client_menu" # Find lost windows
      "$mainMod, escape, exec, pypr toggle term" # Toggle terminal
      
      # Launch apps
      "$mainMod SHIFT, B, exec, ${apps.browser}"
      "$mainMod, E, exec, ${apps.fileManager}"
      "$mainMod SHIFT, L, exec, hyprlock"
      "$mainMod, Return, exec, ${apps.terminal}"
      "$mainMod SHIFT, Return, exec, ${apps.launcher}"
      
      # Window actions
      ",F11,fullscreen"
      "$mainMod, F, togglefloating"
      "$mainMod, G, togglegroup"
      "$mainMod, P, pseudo, # dwindle"
      "$mainMod, Q, killactive"
      "$mainMod, S, togglesplit, # dwindle"
      "$mainMod, U, moveoutofgroup"
      
      # Media controls
      "$mainMod, F3, exec, brightnessctl -d *::kbd_backlight set +33%"
      "$mainMod, F2, exec, brightnessctl -d *::kbd_backlight set 33%-"
      ", XF86AudioRaiseVolume, exec, pamixer -i 5 "
      ", XF86AudioLowerVolume, exec, pamixer -d 5 "
      ", XF86AudioMute, exec, pamixer -t"
      ", XF86AudioMicMute, exec, pamixer --default-source -m"
      ", XF86MonBrightnessDown, exec, brightnessctl set 5%- "
      ", XF86MonBrightnessUp, exec, brightnessctl set +5% "
      
      # Copy/Paste
      '', Print, exec, grim -g "$(slurp)" - | swappy -f -''
      "$mainMod, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
      
      # Waybar restart
      "$mainMod, B, exec, pkill -SIGUSR1 waybar"
      "$mainMod, W, exec, pkill -SIGUSR2 waybar"
      
      # Toggle Touchpad
      "$mainMod, T, exec, ~/.config/scripts/hypr/toggle-touchpad.sh"
    ];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
  };
}
