{ pkgs, ... }:
{
  programs = {
    firefox = {
      policies = {
        ExtensionSettings =
          with pkgs.nur.repos.rycee.firefox-addons;
          builtins.mapAttrs
            (_: install_url: {
              installation_mode = "force_installed";
              inherit install_url;
            })
            {
              "${darkreader.addonId}" = "${darkreader.src.url}";
              "${bitwarden.addonId}" = "${bitwarden.src.url}";
              "${tampermonkey.addonId}" = "${tampermonkey.src.url}";
              "${stylus.addonId}" = "${stylus.src.url}";
              "${xbrowsersync.addonId}" = "${xbrowsersync.src.url}";
              "${improved-tube.addonId}" = "${improved-tube.src.url}";
              "${ublock-origin.addonId}" = "${ublock-origin.src.url}";
            };
      };
      profiles.marcmiller = {
        search = {
          force = true;
          default = "google";
          order = [
            "google"
          ];
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "NixOS Wiki" = {
              urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
              icon = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };
            "Home Manager Options Search" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=release-25.05";
                }
              ];
              icon = "https://home-manager-options.extranix.com/images/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@hm" ];
            };
            "bing".metaData.hidden = true;
            "google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
          };
        };

        settings = {
          "extensions.autoDisableScopes" = 0;
          "media.webrtc.capture.allow-pipewire" = true;
          "media.hardwaremediakeys.enabled" = false;
        };
      };
    };
  };
}
