{
  lib,
  ...
}:
{
  programs.zed-editor = {
    installRemoteServer = true;
    userSettings = {
      lsp.rust-analyzer.binary = {
        path_lookup = true;
        ignore_system_versions = false;
      };
      indent_guides = {
        enabled = true;
        coloring = "indent_aware";
        background_coloring = "indent_aware";
      };
      relative_line_numbers = lib.mkForce false;
      tab_size = 2;
      theme = lib.mkForce {
        mode = "dark";
        dark = "Base16 Stylix";
        light = "Base16 Stylix";
      };
      icon_theme = "Catppuccin Mocha";
      autosave = lib.mkForce {
        after_delay.milliseconds = 2000;
      };
      vim_mode = lib.mkForce false;
    };
    extensions = lib.mkForce [
      "nix"
      "catppuccin"
      "catppuccin-icons"
      "toml"
      "dockerfile"
      "docker compose"
      "git firefly"
      "rust-src"
    ];
  };
}
