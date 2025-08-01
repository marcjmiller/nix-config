{
  lib,
  ...
}:
{
  programs.zed-editor = {
    userSettings = {
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
        background_coloring = "indent_aware";
      };
      relative_line_numbers = lib.mkForce false;
      tab_size = 2;
      theme = lib.mkForce {
        mode = "dark";
        dark = "Catppuccin Mocha";
        light = "Catppuccin Latte";
      };
      icon_theme = "Catppuccin Mocha";
    };

    extensions = lib.mkForce [
      "nix"
      "catppuccin"
      "catppuccin-icons"
      "toml"
      "docker"
      "docker compose"
      "git firefly"
    ];
  };
}
