{ ... }:
{
  programs.zsh = {
    sessionVariables = {
      EDITOR = "vim";
      BROWSER = "brave";
    };

    shellAliases = {
      pp = "pulumi";
      creds = "source ~/.config/2fctl/credentials.sh";
      shell = "nix develop -c $SHELL";
      homecfg = "cd ~/nix-config && zed .";
    };
  };
}
