{
  lib,
  config,
  ...
}:
let
  inherit (import ../variables.nix)
    betterTransition
    ;
in
with lib;
{
  programs.waybar = lib.mkForce {
    enable = true;

    style = concatStrings [
      ''
        * {
          font-family: JetBrainsMono Nerd Font Mono;
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
        #window, #pulseaudio, #cpu, #memory, #idle_inhibitor {
          font-weight: bold;
          margin: 4px 0px;
          margin-left: 7px;
          padding: 0px 18px;
          background: #${config.lib.stylix.colors.base00};
          color: #${config.lib.stylix.colors.base08};
          border-radius: 8px 8px 8px 8px;
        }
        #idle_inhibitor {
        font-size: 28px;
        }
        #custom-os_button {
          color: #${config.lib.stylix.colors.base0B};
          background: #${config.lib.stylix.colors.base02};
          font-size: 22px;
          margin: 8px;
          padding: 0px 10px;
          border-radius: 16px 16px 16px 16px;
        }
        #custom-hyprbindings, #network, #battery,
        #custom-notification, #tray, #custom-exit {
          /* font-weight: bold; */
          font-size: 20px;
          background: #${config.lib.stylix.colors.base00};
          color: #${config.lib.stylix.colors.base08};
          margin: 4px 0px;
          margin-right: 7px;
          border-radius: 8px 8px 8px 8px;
          padding: 0px 18px;
        }
        #clock {
          font-weight: bold;
          font-size: 16px;
          color: #0D0E15;
          background: linear-gradient(90deg, #${config.lib.stylix.colors.base0B}, #${config.lib.stylix.colors.base02});
          margin: 0px;
          padding: 0px 5px 0px 5px;
          border-radius: 16px 16px 16px 16px;
        }
      ''
    ];
  };
}
