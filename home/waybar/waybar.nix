{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ../variables.nix)
    betterTransition
    terminal
    ;
in
with lib;
{
  programs.waybar = lib.mkForce {
    enable = true;

    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "custom/launcher"
          "idle_inhibitor"
          "hyprland/window"
        ];
        modules-center = [
          "hyprland/workspaces"
        ];
        modules-right = [
          "tray"
          "group/hardware"
          "clock"
          "custom/exit"
        ];
        network = {
          interval = 1;
          format-disconnected = "Disconnected :warning:";
          format-ethernet = "";
          format-linked = "{ifname} (No IP) ";
          format-wifi = "{essid} ";
          on-click = "";
        };
        pulseaudio = {
          scroll-step = 1;
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
            ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        "custom/launcher" = {
          format = "";
          icon-size = 24;
          on-click = "fuzzel";
          tooltip = false;
        };
        "hyprland/workspaces" = {
          show-special = false;
          format = "{icon}";
          format-icons = {
            # default = " ";
            # active = " ";
            # urgent = " ";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "dev";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
          };
        };
        "hyprland/window" = {
          format = "{class}";
          max-length = 20;
          separate-outputs = false;
          rewrite = {
            "" = "No Windows?";
          };
        };
        "group/hardware" = {
          orientation = "horizontal";
          modules = [
            "battery"
            "cpu"
            "temperature"
            "memory"
            "network"
            "pulseaudio"
          ];
          drawer = {
            transition-duration = 500;
          };
        };
        "temperature" = {
          "hwmon-path" = "/sys/devices/platform/coretemp.0/hwmon/hwmon6/temp1_input";
          "format" = "{temperatureC}°C";
        };
        "memory" = {
          tooltip = true;
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip = "true";
        };
        "tray" = {
          spacing = 12;
          icon-theme = "Papirus";
        };
        "custom/exit" = {
          tooltip = false;
          format = "";
          on-click = "sleep 0.1 && hyprctl dispatch exit";
        };
        "clock" = {
          format = " {:L%I:%M %p %Z}";
          timezones = [
            "America/New_York"
            "Etc/UTC"
          ];
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            on-scroll = 1;
            format = {
              today = "<span color='#47FF51'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "tz_up";
          };
        };
        "battery" = {
          bat = "BAT0";
          interval = 60;
          states = {
            "warning" = 30;
            "critical" = 1;
          };
          format = "{icon} {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          max-length = 25;
        };
        "cpu" = {
          interval = 1;
          format = "{icon} {usage}%";
          format-icons = [
            "<span color='#69ff94'>▁</span>" # green
            "<span color='#2aa9ff'>▂</span>" # blue
            "<span color='#f8f8f2'>▃</span>" # white
            "<span color='#f8f8f2'>▄</span>" # white
            "<span color='#ffffa5'>▅</span>" # yellow
            "<span color='#ffffa5'>▆</span>" # yellow
            "<span color='#ff9977'>▇</span>" # orange
            "<span color='#dd532e'>█</span>" # red
          ];
        };
        "memory" = {
          interval = 30;
          format = "{used:0.1f}G/{total:0.1f}G ";
        };
      };
    };

    style = concatStrings [
      ''
        * {
          font-family: JetBrainsMono NFP;
          font-size: 18px;
          border-radius: 0px;
          border: none;
          min-height: 0px;
        }
        window#waybar {
          background: rgba(0,0,0,0);
        }
        #workspaces {
          color: #${config.lib.stylix.colors.base00};
          background: #${config.lib.stylix.colors.base01};
          margin: 4px 4px;
          padding: 5px 5px;
          border-radius: 16px;
          font-size: 16px;
        }
        #workspaces button {
          font-weight: bold;
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: #${config.lib.stylix.colors.base00};
          background: linear-gradient(45deg, #${config.lib.stylix.colors.base08}, #${config.lib.stylix.colors.base0D});
          opacity: 0.5;
          transition: ${betterTransition};
          min-width: 25px;
        }
        #workspaces button.active {
          font-weight: bold;
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: #${config.lib.stylix.colors.base00};
          background: linear-gradient(45deg, #${config.lib.stylix.colors.base08}, #${config.lib.stylix.colors.base0D});
          transition: ${betterTransition};
          opacity: 1.0;
          min-width: 40px;
        }
        #workspaces button:hover {
          font-weight: bold;
          border-radius: 16px;
          color: #${config.lib.stylix.colors.base00};
          background: linear-gradient(45deg, #${config.lib.stylix.colors.base08}, #${config.lib.stylix.colors.base0D});
          opacity: 0.8;
          transition: ${betterTransition};
        }
        tooltip {
          background: #${config.lib.stylix.colors.base00};
          border: 1px solid #${config.lib.stylix.colors.base08};
          border-radius: 12px;
        }
        tooltip label {
          color: #${config.lib.stylix.colors.base08};
        }
        #window {
          font-weight: bold;
          margin: 8px 0;
          padding: 0px 18px;
          background: #${config.lib.stylix.colors.base00};
          color: #${config.lib.stylix.colors.base08};
          border-radius: 8px 8px 8px 8px;
        }
        #battery, #pulseaudio, #cpu, #memory,
        #network, #idle_inhibitor, #clock,
        #tray, #temperature, #custom-exit {
          font-weight: bold;
          margin: 8px 7px 8px 0;
          padding: 0px 18px;
          background: #${config.lib.stylix.colors.base00};
          color: #${config.lib.stylix.colors.base08};
          border-radius: 8px 8px 8px 8px;
        }
        #custom-launcher, #custom-exit {
          color: #${config.lib.stylix.colors.base00};
          background: #${config.lib.stylix.colors.base02};
          font-size: 28px;
          margin: 8px;
          padding: 0px 10px;
          border-radius: 16px 16px 16px 16px;
        }
        #custom-exit {
          font-size: 20px;
          padding: 0px 10px;
          border-radius: 16px;
        }
        #tray {
          font-size: 20px;
          background: #${config.lib.stylix.colors.base00};
          color: #${config.lib.stylix.colors.base08};
          border-radius: 8px 8px 8px 8px;
          padding: 0px 18px;
        }
        #clock {
          color: #${config.lib.stylix.colors.base00};
          background: linear-gradient(90deg, #${config.lib.stylix.colors.base0B}, #${config.lib.stylix.colors.base02});
        }
      ''
    ];
  };
}
